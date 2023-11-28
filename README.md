# MinUI-Extra-Paks
Set of unofficial extra paks for MinUI (https://github.com/shauninman/MinUI)

MinUI is a focused, custom launcher and libretro frontend for the RGB30, Trimui Smart (and Pro), Miyoo Mini (and Plus), M17, and Anbernic RG35XX, created by @shauninman

<img src="https://raw.githubusercontent.com/shauninman/MinUI/main/github/minui-main.png" width=320 /> <img src="https://raw.githubusercontent.com/shauninman/MinUI/main/github/minui-menu-gbc.png" width=320 />  
See [more screenshots](https://github.com/shauninman/MinUI/tree/main/github).

## Compatible devices

> By the moment only M17 is supported because I only have this unit for testing, if you want to add support for more devices feel free to propose a PR.

- M17

## Supported consoles

- Amstrad CPC
- MAME
- Neo geo
- Atari 2600
- Atari 5200
- Atari 7800
- Atari Lynx
- Game & Watch
- Sega 32X
- ZX Spectrum

## How to install

Simply copy the last release files over the root folder of SD Card.

## How to build

Requiremenst:
- Docker
- Git
- Make

clone repository and run:
```
make all PLATFORMS=[platforms]
```

For example if you want to build extra packs for M17 run:
```
make all PLATFORMS=m17
```
