{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = import nixpkgs {
        inherit system;
      };
        bedrock-connect = (with pkgs;
          stdenv.mkDerivation {
            pname = "bedrock-connect";
            version = "1.59";
            src = fetchurl {
              url = "https://github.com/Pugmatt/BedrockConnect/releases/download/1.59/BedrockConnect-1.0-SNAPSHOT.jar";
              hash = "sha256-vB0ycSLdoSiEMgO7+pXAGpuUUd29mxC1v+ozXfStaeg=";
            };
            phases = ["installPhase"];
            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/BedrockConnect-1.0-SNAPSHOT.jar
            '';
          }
        );
      in rec {
        defaultApp = flake-utils.lib.mkApp {
          drv = defaultPackage;
        };
        defaultPackage = bedrock-connect;
      }
    );
}
