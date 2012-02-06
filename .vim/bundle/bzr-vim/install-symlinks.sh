#! /bin/sh

# Install symlinks in ~/.vim/<kind>/bzr*.vim to ./<kind>/bzr*.vim

set -e

DOT_VIM="$HOME/.vim"
BZR_VIM=$(cd `dirname $0` && pwd)

cd "$BZR_VIM"

for d in */; do
    if [ ! -d "$DOT_VIM/$d" ]; then
    	mkdir -p "$DOT_VIM/$d"
    fi
    for f in ${d}bzr*.vim; do
    	if [ ! -e "$DOT_VIM/$f" ]; then
    	    ln -sf "$BZR_VIM/$f" "$DOT_VIM/$f"
	else
	    echo >&2 "'$DOT_VIM/$f' exists, skipping."
	fi
    done
done
