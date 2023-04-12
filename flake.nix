{
  description = "GTK-based lockscreen for Wayland ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      version =
        if (self ? rev)
        then self.rev
        else "dev";

      nativeBuildInputs = with pkgs; [scdoc pkg-config wayland-scanner glib];
      buildInputs = with pkgs; [wayland gtk3 pam gtk-layer-shell];
    in {
      packages = rec {
        default = gtklock;

        gtklock = pkgs.stdenv.mkDerivation {
          inherit version buildInputs nativeBuildInputs;
          pname = "gtklock";
          installFlags = ["DESTDIR=$(out)" "PREFIX="];
          strictDeps = true;
          src = ./.;
        };
      };

      devShell = pkgs.mkShell {
        name = "gtklock-shell";
        inherit nativeBuildInputs buildInputs;
      };
    });
}
