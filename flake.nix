{
  description = "Nix flake for ModularCalculator (builds the Python package)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
        py = pkgs.python311;
        pyPkgs = pkgs.python311Packages;
        pname = "modularcalculator";
        version = "1.5.0";
      in rec {
        packages.${pname} = pyPkgs.buildPythonPackage rec {
          inherit pname version;
          src = self;
          pyproject = true;

          nativeBuildInputs = [ pyPkgs.setuptools ];

          propagatedBuildInputs = [ pyPkgs.pyyaml pyPkgs.scipy ];

          postPatch = ''
            sed -i 's/unittest.main(exit=False)/unittest.main(exit=True)/g' tests/testrunner.py
          '';

          #checkPhase = ''
          #  PYTHONPATH=$PYTHONPATH:$PWD ${py.interpreter} tests/tests.py
          #'';

          meta = with lib; {
            description = "Powerful modular calculator engine";
            homepage = "https://github.com/JordanL2/ModularCalculator";
            license = licenses.asl20;
            maintainers = with maintainers; [ Tommimon ];
          };
        };

        defaultPackage = packages.${pname};
      });
}
