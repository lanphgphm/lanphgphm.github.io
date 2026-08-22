{
  description = "Jekyll dev shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          ruby
          bundler
          jekyll
          # common deps
          libffi
          zlib
        ];
        shellHook = ''
          # Set GEM_HOME
          export GEM_HOME=$PWD/.gem
          export GEM_PATH=$GEM_HOME
          export PATH=$GEM_HOME/bin:$PATH
        '';
      };
    };
}
