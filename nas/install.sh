#!/bin/sh

mkdir -p "$HOME/.ssh"
ln -sf "$HOME/config/nas/ssh/config" "$HOME/.ssh/config"

ASSETS_SSH_DIR="$HOME/config/assets/ssh"
IPHONE171_PUBKEY=$(cat "$ASSETS_SSH_DIR/iphone171/kitsutsuki.pub")
UGUISU_MOMEEMT_PUBKEY=$(cat "$ASSETS_SSH_DIR/uguisu/momeemt/kitsutsuki.pub")
AUTHORIZED_KEYS_FILE="$HOME/.ssh/authorized_keys"
{
  echo "$IPHONE171_PUBKEY"
  echo "$UGUISU_MOMEEMT_PUBKEY"
} >"$AUTHORIZED_KEYS_FILE"
