{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
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
            version = "1.53";
            src = fetchurl {
              url = "https://github.com/Pugmatt/BedrockConnect/releases/download/1.54.1/BedrockConnect-1.0-SNAPSHOT.jar";
              hash = "sha256-0/Msnk1aLP8IqYGZrhqzXX59wcFaaha7mMhZTvt+7sM=";
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
