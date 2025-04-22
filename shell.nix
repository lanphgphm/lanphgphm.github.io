{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    ruby
    bundler
    jekyll

    # common deps
    libffi
    zlib
  ];

  shellHook = ''
    zsh
    # Set GEM_HOME 
    export GEM_HOME=$PWD/.gem
    export GEM_PATH=$GEM_HOME
    export PATH=$GEM_HOME/bin:$PATH
  '';
}
