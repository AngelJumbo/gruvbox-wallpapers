{
  description = "Gruvbox-inspired wallpaper collection";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs {inherit system;}));

    mkWallpapersPkg = pkgs: name: path:
      pkgs.stdenv.mkDerivation {
        pname = "gruvbox-wallpapers-${name}";
        version = self.shortRev or "dev";
        src = ./.;
        installPhase = ''
          mkdir -p $out
          ${
            if name == "default"
            then "find wallpapers -type f -exec cp {} $out/ \\;"
            else "cp -r ${path}/* $out/"
          }
        '';
      };

    subdirs = {
      default = "wallpapers";
      anime = "wallpapers/anime";
      brands = "wallpapers/brands";
      game = "wallpapers/game";
      minimalistic = "wallpapers/minimalistic";
      mix = "wallpapers/mix";
      painting = "wallpapers/painting";
      photography = "wallpapers/photography";
      pixelart = "wallpapers/pixelart";
      renders = "wallpapers/renders";
    };
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (
      pkgs:
        nixpkgs.lib.mapAttrs (name: path: mkWallpapersPkg pkgs name path) subdirs
    );
  };
}
