{
  description = "BiliSail, packaged from the official Linux AppImage";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      # Upstream has no license yet, so the package is marked unfree; allow just this one.
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "bilisail";
      };
      bilisail = pkgs.callPackage ./nix/package.nix { };
    in
    {
      packages.${system} = {
        inherit bilisail;
        default = bilisail;
      };
      apps.${system}.default = {
        type = "app";
        program = "${bilisail}/bin/bilisail";
      };
    };
}
