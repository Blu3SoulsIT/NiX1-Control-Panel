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
        name = "Swiftpoint X1 Control Panel";
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
          pname = name;
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
            chmod +x "$out/${name}"

            rsync -a --mkpath ./profiles/Desktop/logo.png $out/share/icons/swiftpoint.png

            mkdir $out/bin
            ln -s "$out/${name}" "$out/bin/${name}"

            rsync -a --mkpath ./*.rules $out/etc/udev/rules.d/

            runHook postInstall
          '';

          desktopItems = [ 
            (pkgs.makeDesktopItem  {
              name = name;
              exec = "\"${name}\"";
              icon = "swiftpoint.png";
              genericName = "X1 Control Panel by Swiftpoint";
              desktopName = name;
              categories = [ "Utility" ];
              keywords = [ "x1" "swiftpoint" "mouse" ];
            })
          ];

          meta = with pkgs.lib; {
            description = "X1 Control Panel by Swiftpoint";
            homepage = "https://www.swiftpoint.com";
          };
        };

        apps.default = {
          type = "app";
          program = "\"${config.packages.default}/${name}\"";
        };
      };
      flake = {};
    };
}
