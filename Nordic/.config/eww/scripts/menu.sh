#!/bin/bash

state=$(eww get open_menu)

open_menu() {
    if [[ -z $(eww windows | grep '*menu') ]]; then
        eww open menu
    fi
    eww update open_menu=true
}

close_menu() {
    eww update open_menu=false
}

case $1 in
    close)
        close_menu
        exit 0;;
esac

case $state in
    true)
        close_menu;;
    false)
        open_menu;;
esac