{
  description = "GitHub Copilot app packaged as a Nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "github-copilot-app";
          };
          package = pkgs.callPackage ./package.nix { };
        in
        {
          default = package;
          github-copilot-app = package;
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/github-copilot-app";
          meta.description = "GitHub Copilot app";
        };
      });

      formatter = forAllSystems (system: (import nixpkgs { inherit system; }).nixfmt);
    };
}
