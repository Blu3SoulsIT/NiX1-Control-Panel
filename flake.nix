{
  description = "X1 Control Panel software for Swiftpoint mouse products.";

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

        packages.default = pkgs.callPackage ./packages/x1-control-panel { inherit name; };

        apps.default = {
          type = "app";
          program = "\"${config.packages.default}/${name}\"";
        };
      };
      flake = {};
    };
}
