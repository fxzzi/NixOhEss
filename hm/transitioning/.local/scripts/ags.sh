#!/usr/bin/env bash

HOST=$(hostname)

if [ "$HOST" = "Kappa" ]; then
    uwsm app -- agsv1 -c ~/.config/agsv1/config.js
elif [ "$HOST" = "faarnixOS" ]; then
    ags -c ~/.config/agsv1/config.js
fi
