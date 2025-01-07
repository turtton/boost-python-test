{

  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
				python = pkgs.python312Full.debug;
        boostDev = (pkgs.boost.override { inherit python; enablePython = true; }).dev;
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        packages.boost = boostDev;
        packages.default = pkgs.stdenv.mkDerivation {
          name = "robot";
          src = ./.;
          buildInputs = with pkgs; [
            cmake
            boostDev
						python
          ];
          cmakeFlags = [
            "-DCMAKE_CXX_STANDARD=20"
          ];
        };
        devShells.default = pkgs.mkShell {
            packages = with pkgs; [
             bashInteractive
             cmake
             python
            ];

			buildInputs = with pkgs; [
             boostDev
		     python
			];

			shellHook = ''
			  #export Boost_DIR=${boostDev}/lib/cmake/Boost-1.81.0/
			  export Boost_ROOT=${boostDev}
			'';
        };
      }
    );
}
