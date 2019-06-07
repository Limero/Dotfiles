export EDITOR=vim
export GDK_BACKEND=wayland

[ -n "$BASH" -a -f ~/.bashrc ] && . ~/.bashrc

#if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#  exec startx
#fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec sway
fi
