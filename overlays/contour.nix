# Overlay derived from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/terminal-emulators/contour/default.nix
inputs: self: super: {
  contour = with super; let
    # Commits refs come from https://github.com/contour-terminal/contour/blob/master/scripts/install-deps.sh
    libunicode-src = fetchFromGitHub {
      owner = "contour-terminal";
      repo = "libunicode";
      rev = "f464e0ffdb560cd20d8556226248d36e1b85d1a3";
      sha256 = "sha256-5JpG1ExqdjMtFocmHJ5iuJEGtQbyrpVWnL4GNZyJLnk=";
    };

    termbench-pro-src = fetchFromGitHub {
      owner = "contour-terminal";
      repo = "termbench-pro";
      rev = "cd571e3cebb7c00de9168126b28852f32fb204ed";
      sha256 = "sha256-dNtOmBu63LFYfiGjXf34C2tiG8pMmsFT4yK3nBnK9WI=";
    };
  in
    stdenv.mkDerivation rec {
      pname = "contour";
      version = "0.3.4.223";

      src = fetchFromGitHub {
        owner = "contour-terminal";
        repo = pname;
        rev = "v${version}";
        sha256 = "sha256-M76d4rzQNheE0LTz9+qX/K0/FxEZPeDVpH3CQHLTYzM=";
      };

      nativeBuildInputs = [
        cmake
        pkg-config
        ncurses
        file
        qt5.qtmultimedia.bin
      ];

      buildInputs =
        [
          fontconfig
          freetype
          libGL
          pcre
          boost
          catch2
          fmt_9
          microsoft_gsl
          range-v3
          libyamlcpp
          qt5.qtx11extras.dev
          qt5.qtmultimedia.dev
          qt5.wrapQtAppsHook
        ]
        ++ lib.optionals stdenv.isDarwin [darwin.apple_sdk.libs.utmp];

      preConfigure = ''
        echo "v${version}" > version.txt

        mkdir -p _deps/sources

        cat > _deps/sources/CMakeLists.txt <<EOF
        macro(ContourThirdParties_Embed_libunicode)
            add_subdirectory(\''${ContourThirdParties_SRCDIR}/libunicode EXCLUDE_FROM_ALL)
        endmacro()
        macro(ContourThirdParties_Embed_termbench_pro)
            add_subdirectory(\''${ContourThirdParties_SRCDIR}/termbench_pro EXCLUDE_FROM_ALL)
        endmacro()
        EOF

        ln -s ${libunicode-src} _deps/sources/libunicode
        ln -s ${termbench-pro-src} _deps/sources/termbench_pro

        # Don't fix Darwin app bundle
        sed -i '/fixup_bundle/d' src/contour/CMakeLists.txt
      '';

      passthru.tests.test = nixosTests.terminal-emulators.contour;

      meta = with lib; {
        # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/contour.x86_64-darwin
        broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
        description = "Modern C++ Terminal Emulator";
        homepage = "https://github.com/contour-terminal/contour";
        changelog = "https://github.com/contour-terminal/contour/raw/v${version}/Changelog.md";
        license = licenses.asl20;
        platforms = platforms.unix;
      };
    };
}
