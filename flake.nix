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
            version = "1.62";
            src = fetchurl {
              url = "https://github.com/Pugmatt/BedrockConnect/releases/download/1.62/BedrockConnect-1.0-SNAPSHOT.jar";
              hash = "sha256-8xU/s313uRqB3kEnXhOWdRXbc5osJzik8dOCM6sxasA=";
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
