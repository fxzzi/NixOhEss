# 🇵🇸 NixOhEss 🇵🇸

![NixOhEss Screenshot](showcase.jpg)

## Overview

This repo consists of a relatively simple multi-host configuration using nixOS
and [hjem](https://github.com/feel-co/hjem).

**DISCLAIMER!!** There is no guarantee that these configs will work for you.
These are merely my personal configurations and they do NOT come with a
warranty.

## Hosts

- [fazziPC](./hosts/fazziPC): My main desktop PC, running an AMD 5600x and an
  RTX 3070.
- [fazziGO](./hosts/fazziGO): My Thinkpad L14 Gen 4, which sports an AMD Ryzen 5
  7530U.
- [kunzozPC](./hosts/kunzozPC): My friends gaming PC, where I manage his NixOS
  installation.

## Structure

- [`flake.nix`](./flake.nix): The flake which declares entry points and inputs
  for my entire configuration.
- [`modules/`](./modules/): This contains all host-agnostic modules which I use
  across all devices. A lot of the modules are optional, and can be configured
  in the host specific config.
- [`hosts/`](./hosts/): The configurations for each host is contained here. This
  is where the hardware configurations and host-specific modules are kept.

## SPECIAL THANKS

- [raf](https://github.com/NotAShelf) for nvf and helping with a lot of stuff
- [Nobbz](https://github.com/NobbZ) for helping a ton over discord
- [feel-co](https://github.com/feel-co) for making hjem
- [nezia](https://github.com/nezia1) for helping with hjem :)
- the others which i wasn't able to mention here!!

## License

This project is licensed under the MIT License. You are free to read the terms
of the license here: [LICENSE](./LICENSE)

I'm happy for others to benefit from my config, but give credit where credit is
due :)
