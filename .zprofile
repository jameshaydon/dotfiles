export ALTERNATE_EDITOR=""
export EDITOR="/usr/bin/emacsclient -c"
export VISUAL=$EDITOR

# Add stack's binary directory to path
BIN_DIR=$(stack path --local-bin)
export PATH=$PATH:$BIN_DIR

# Radicle stuff
export RADPATH=$HOME/dev/radicle/rad
export PATH=$PATH:$HOME/dev/radicle/bin
export IPFS_API_URL=http://127.0.0.1:9301

export VARINDOTZPROFILE=42
