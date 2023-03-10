{
  nixpkgs ? import ./nixpkgs.nix { },
  poetry2nix ? import (fetchTarball "https://github.com/nix-community/poetry2nix/archive/refs/tags/1.36.0.tar.gz") { pkgs = nixpkgs; poetry = nixpkgs.poetry; },
}:
  poetry2nix.mkPoetryApplication {
    projectDir = ./.;
    python = nixpkgs.python310;
    preferWheels = true;

    overrides = poetry2nix.overrides.withDefaults (self: super: {
      cython = null;
    });

    # https://github.com/NixOS/nixpkgs/issues/56943
    strictDeps = false;

    nativeBuildInputs = [
      nixpkgs.wrapGAppsHook
      nixpkgs.gobject-introspection
    ];

    buildInputs = [
      nixpkgs.gst_all_1.gstreamer
      nixpkgs.gst_all_1.gst-plugins-base
      nixpkgs.gst_all_1.gst-plugins-good
      nixpkgs.gst_all_1.gst-vaapi
    ];

    propagatedBuildInputs = [
      nixpkgs.python310.pkgs.gst-python
      nixpkgs.python310.pkgs.pygobject3
    ];

  }
