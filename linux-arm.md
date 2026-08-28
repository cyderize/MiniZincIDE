# Plan: ARM64 Linux packages

## Goal and scope

Add native `aarch64-linux-gnu` builds to the existing CI workflow and publish
the same Linux deliverables as x86_64:

- a `MiniZincIDE-<version>-aarch64-linux-gnu.tgz` bundle;
- an `aarch64` AppImage; and
- an ARM64 Snap alongside the existing AMD64 Snap.

Use native ARM64 execution, not cross-compilation or QEMU.  This makes the
IDE, Qt deployment tools, MiniZinc compiler, and bundled solvers all agree on
their architecture, and permits the test suite to execute the produced
binaries.

## Preconditions

1. Confirm that the selected `libminizinc` release (including `edge`) has a
   `minizinc-compiler-only-aarch64-linux-gnu.tar.gz` asset and that every
   dependency named by its `vendor.lock` has the corresponding
   `aarch64-linux-gnu` asset. `scripts/fetch_minizinc.sh` already derives the
   asset names from the triple, so no script change is needed if those release
   assets exist.
2. Confirm the `findMUS`, `mzn-analyse`, and Globalizer ARM64 release assets.
   Unlike Windows ARM64, Linux ARM64 must include Globalizer, so an absent
   Globalizer asset would block the normal Linux payload.
3. Run an initial ARM64 build with the unmodified deployment sequence. In
   particular, verify that the current manylinux dependency list has all of
   the ARM64 packages and that linuxdeploy's Qt plugin completes. Treat this
   as a gate for promising an ARM64 AppImage: linuxdeploy has an unresolved
   upstream report of ARM64 hangs, so retain build logs and either pin a known
   working release or investigate upstream if it reproduces.

## CI matrix and container changes

1. Add a `linux-arm` entry to both the `build` and `test` matrices in
   `.github/workflows/ci.yml`:

   ```yaml
   - { platform: linux-arm, triple: aarch64-linux-gnu,
       runner: ubuntu-24.04-arm,
       manylinux_image: quay.io/pypa/manylinux_2_28_aarch64,
       appimage_arch: aarch64 }
   ```

   `ubuntu-24.04-arm` provides a native ARM64 GitHub-hosted runner, and
   `manylinux_2_28_aarch64` preserves the existing glibc 2.28 compatibility
   floor. Keep the existing x86_64 image for the `linux` entry; do not replace
   the global image with the ARM image.
2. Make the Linux-only workflow conditions include both Linux identifiers
   (for example, `startsWith(matrix.platform, 'linux')`), including build,
   package, Snap, and test steps. Keep the non-Linux Qt installation condition
   as the complement of that broader Linux condition.
3. Pass the matrix-specific manylinux image to every `docker run`, instead of
   using the current architecture-fixed `MANYLINUX_IMAGE` environment value.
   The version can remain a shared environment value if the architecture
   suffix is constructed from a separate matrix field, but keeping the full
   image in the matrix is clearer and avoids expression/quoting mistakes.
4. Retain `check-version` as an x86_64 fetch-only check. It verifies version
   agreement rather than package architecture; the ARM64 build and test jobs
   will validate ARM64 availability.

## ARM-aware build and packaging scripts

1. Extend `scripts/linux_build_env.sh` to select the Qt host and architecture
   from an explicit environment variable (for example `LINUX_ARCH`):

   | Target | aqt host | aqt architecture |
   | --- | --- | --- |
   | x86_64 | `linux` | `linux_gcc_64` (accept legacy `gcc_64`) |
   | aarch64 | `linux_arm64` | `linux_gcc_arm64` |

   Pass this variable from the workflow's Linux matrix. Continue discovering
   the x86_64 legacy spelling where necessary, but fail clearly if the selected
   Qt 6.9.3 ARM64 package or `qtwebsockets` module is unavailable. Qt's ARM64
   online packages use a distinct `linux_arm64` host, so merely changing the
   architecture regex is insufficient.
2. Make `scripts/build_ide.sh` choose architecture-specific linuxdeploy and
   Qt-plugin assets. Download `linuxdeploy-aarch64.AppImage` and
   `linuxdeploy-plugin-qt-aarch64.AppImage` for ARM64, while retaining the
   existing x86_64 names for AMD64. Keep `APPIMAGE_EXTRACT_AND_RUN=1`, since
   the container still has no FUSE.
3. In the workflow's package step, download
   `appimagetool-aarch64.AppImage` for ARM64, and pass an `APPIMAGE_ARCH`
   value to the packaging script. Update `scripts/package_ide.sh` to use
   `ARCH="$APPIMAGE_ARCH"` rather than its hard-coded `ARCH=x86_64`.
   The tarball assembly itself is architecture-neutral; its filename already
   uses the supplied triple. Do not call an x86_64 AppImage tool from an ARM64
   runner.
4. Keep the existing `patchelf`, `strip`, and RPATH operations, but add a
   post-package inspection step for both architectures: use `file`/`readelf`
   to confirm that the executable, `fzn-gecode`, `libhighs`, and the AppImage
   report AArch64 for the ARM64 job; run `minizinc --solvers` from the staged
   bundle; and start the IDE with `QT_QPA_PLATFORM=offscreen` (or otherwise
   run its existing test suite). This catches accidental mixed-architecture
   payloads before upload.

## Snap and publication changes

1. Run the existing Snap preparation and `snapcore/action-build` for both
   Linux matrix entries. Snapcraft builds for the native runner architecture,
   and `snapcraft.yaml` already uses `${CRAFT_ARCH_TRIPLET_BUILD_FOR}` for the
   architecture-specific Mesa driver directory. Verify the produced Snap's
   architecture metadata and launch it on ARM64 before enabling Store uploads.
2. Preserve separate artifact names (`ide-linux` and `ide-linux-arm`), so the
   tarballs/AppImages/Snaps cannot collide during upload. The existing filename
   triple already distinguishes the non-Snap packages.
3. Change `publish` so it publishes *all* downloaded Snap artifacts, not the
   first result of `find ... | head -1`. Give the publish action one native
   Snap at a time (a matrix/job or loop with the action invoked per artifact),
   targeting the same `edge`/`candidate` channel. Validate that both AMD64 and
   ARM64 revisions are attached to the same Store release before promotion.
   Keep excluding `*.snap` from GitHub Release assets unless publishing Snap
   files there is an intentional policy change.
4. Update `promote-snap` only if it cannot promote a multi-architecture Store
   release with the current input. Prefer promotion by Snap Store revision or
   channel for the combined release, rather than adding a second manual input
   that can leave architectures on different channels.

## Rollout and acceptance criteria

1. Land the script changes and run the expanded matrices on a pull request;
   initially leave Snap Store publication disabled for ARM64 if Store review
   or naming needs confirmation.
2. On a `develop` build, verify the `aarch64-linux-gnu` `.tgz` and AppImage on
   an ARM64 Linux host: the IDE launches, bundled `minizinc --solvers` lists
   the expected solvers, and a small solve succeeds.
3. Verify the ARM64 Snap install and launch, then confirm both architectures
   are available in the intended Snap channel.
4. On the next tag, ensure GitHub Release assets contain exactly one ARM64
   tarball and AppImage with the release version, and the Snap Store's
   `candidate` release contains both ARM64 and AMD64 revisions. Only then use
   the existing stable-promotion procedure.

## Sources checked

- GitHub's hosted-runner reference documents `ubuntu-24.04-arm` as an ARM64
  Linux label: <https://docs.github.com/en/actions/reference/runners/github-hosted-runners>.
- The manylinux project publishes
  `quay.io/pypa/manylinux_2_28_aarch64` with a glibc 2.28 floor:
  <https://github.com/pypa/manylinux>.
- aqtinstall documents the distinct `linux_arm64` host and
  `linux_gcc_arm64` Qt architecture:
  <https://aqtinstall.readthedocs.io/en/latest/getting_started.html>.
- appimagetool accepts `ARCH=aarch64`:
  <https://github.com/AppImage/appimagetool>.
