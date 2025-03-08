{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = lib.genAttrs systems;
      nixpkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          packages = self.overlays.default null pkgs;
        in
        packages
      );

      legacyPackages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          packages = self.overlays.default null pkgs;
        in
        {
          ryan-mono-dist = pkgs.callPackage ./packages/dist.nix {
            srcs = [
              packages.ryan-mono
              packages.ryan-term
              packages.ryan-mono-nerd-font
              packages.ryan-term-nerd-font
            ];
          };
        }
      );

      overlays.default = _: prev: rec {
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
          src = ryan-mono;
        };

        ryan-term-nerd-font = prev.callPackage ./packages/nerd-font.nix {
          pname = "ryan-term-nerd-font";
          familyName = "Ryan Term NF";
          src = ryan-term;
        };
      };

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixfmt-rfc-style);
    };
}
