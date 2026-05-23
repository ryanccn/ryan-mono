{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system}.extend self.overlays.default;
        in
        {
          inherit (pkgs)
            ryan-mono
            ryan-term
            ryan-mono-nerd-font
            ryan-term-nerd-font
            ;
        }
      );

      legacyPackages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system}.extend self.overlays.default;
        in
        {
          ryan-mono-dist = pkgs.callPackage ./packages/dist.nix {
            srcs = with pkgs; [
              ryan-mono
              ryan-term
              ryan-mono-nerd-font
              ryan-term-nerd-font
            ];
          };
        }
      );

      overlays.default = final: prev: {
        ryan-mono = prev.callPackage ./packages/iosevka.nix {
          pname = "ryan-mono";
          buildPlan = "RyanMono";
        };

        ryan-term = prev.callPackage ./packages/iosevka.nix {
          pname = "ryan-term";
          buildPlan = "RyanTerm";
        };

        ryan-mono-nerd-font = prev.callPackage ./packages/nerd-font.nix {
          pname = "ryan-mono-nerd-font";
          familyName = "Ryan Mono NF";
          src = final.ryan-mono;
        };

        ryan-term-nerd-font = prev.callPackage ./packages/nerd-font.nix {
          pname = "ryan-term-nerd-font";
          familyName = "Ryan Term NF";
          src = final.ryan-term;
        };
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
