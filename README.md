# NixOhEss - 🇵🇸

<p align="center">
  <img src="showcase1.jpg" width="49%">
  <img src="showcase2.jpg" width="49%">
</p>

## Overview

This repo consists of a relatively simple configuration for my desktop and
laptop with nixOS and home-manager.

Feel free to benefit from my config, but I'm by no means a 😎 Nix Pro 😎 so use
it with a grain of salt.

I do want to move to [hjem](https://github.com/feel-co/hjem) in the future but
currently there are two blockers stopping me from using it right now:

- Systemd user services
- GTK / dconf configuration

**DISCLAIMER!!** There is no guarantee that these configs will work for you.
These are merely my personal configurations and they do NOT come with a
warranty.

## Hosts

- fazziPC: My main desktop PC, running an AMD 5600x and an RTX 3070.
- fazziGO: My Thinkpad L14 Gen 4, which sports an AMD Ryzen 5 7530U.
- kunzozPC: My friends gaming PC, where I manage his NixOS installation.

## Structure

- [`flake.nix`](./flake.nix): The flake which declares entry points and inputs
  for my entire configuration.
- [`hosts/`](./hosts/): All of the NixOS related configurations appear here. A
  seperate entrypoint for each host allows toggling of and modifications to
  specific modules.
- [`home/`](./home/): All of my home-manager configuration is contained here. I
  try and do everything I can in userspace, and so the grunt of most graphical
  modules are here.

## SPECIAL THANKS

- [raf](https://github.com/NotAShelf) for nvf and helping with a lot of stuff
- [Nobbz](https://github.com/NobbZ) for helping a ton over discord
- the others which i wasn't able to mention here!!

## License

This project is licensed under the MIT License. You are free to read the terms
of the license here: [LICENSE](./LICENSE)
