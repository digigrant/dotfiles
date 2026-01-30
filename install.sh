#!/usr/bin/env bash
set -e

# establish environment - other scripts and files will ingest this
DOTFILES="$HOME/dotfiles"
echo "export DOTFILES=\"$DOTFILES\"" > "$DOTFILES/env"

link() {
    src="$DOTFILES/$1"
    dst="$HOME/$2"

    # if file already exists and is not a symbolic link, back it up
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
	echo "Backing up $dst -> $dst.bak"
	mv "$dst" "$dst.bak"
    fi

    ln -sfn "$src" "$dst"
    echo "Linked $dst"
}

link bash/bashrc .bashrc
link git/gitconfig .gitconfig
link emacs/init.el .emacs.d/init.el
link emacs/early-init.el .emacs.d/early-init.el
