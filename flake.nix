{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [];
      systems = [ "x86_64-linux" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: 
      let
        version = "3.0.7.20";
        linkId = "a1956a80";
        sha256 = "1wzm0hjxn7kcrh8vm6bjsmvd7m2rzfnkz7dswmvxwgddciwqgxx4";
      in
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            permittedInsecurePackages = [
              "openssl-1.1.1w"
            ];
          };
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "X1 Control Panel";
          inherit version;
          src = fetchTarball {
            url = "https://swiftpointdrivers.blob.core.windows.net/pro/beta/linux/Swiftpoint%20X1%20Control%20Panel%20${version}-${linkId}.tar.xz";
            inherit sha256;
          };

          dontBuild = true;

          nativeBuildInputs = with pkgs; [
            copyDesktopItems
            autoPatchelfHook
            libsForQt5.qt5.wrapQtAppsHook
            rsync
          ];

          buildInputs = with pkgs; [
            dbus-glib
            fontconfig
            glib
            llvmPackages_20.libcxxClang
            libGL
            libsForQt5.qt5.qtsvg
            libsForQt5.qt5.wrapQtAppsHook
            libusb1
            libxkbcommon
            openssl_1_1
            xorg.libX11
            xorg.libXrender
            zlib
          ];

          installPhase = ''
            runHook preInstall

            rsync -ra --no-links --mkpath . $out
            chmod +x "$out/Swiftpoint X1 Control Panel"

            runHook postInstall
          '';

          desktopItems = [ 
            (pkgs.makeDesktopItem  {
              name = "Swiftpoint X1 Control Panel";
              exec = "Swiftpoint X1 Control Panel";
              icon = "Swiftpoint X1 Control Panel";
              genericName = "Swiftpoint X1 Control Panel";
              desktopName = "Swiftpoint X1 Control Panel";
              categories = [ "Utility" ];
            })
          ];

          meta = with pkgs.lib; {
            description = "X1 Control Panel by Swiftpoint";
            homepage = "https://www.swiftpoint.com";
          };
        };

        apps.default = {
          type = "app";
          program = "${config.packages.default}/Swiftpoint X1 Control Panel";
        };
      };
      flake = {};
    };
}
