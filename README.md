# Initial D Arcade Stage 8 Infinity BGM AutoMod

> Mostly-automated custom soundtrack modding workflow for Initial D Arcade Stage 8 Infinity.

A Windows CMD-based toolchain for replacing the game's music with custom tracks, generating previews, managing XACT projects and packaging ready-to-use mod files.

Created by **Metasharp**.

---

# Features

* Automatic game backup
* ADPCM extraction via `unxwb`
* PCM conversion via `ffmpeg`
* Automatic preview generation
* XACT project bootstrap & launching
* songs.ini auto-generation from filenames
* Automatic mod packaging
* Optional automatic patching into the game folder

---

# Folder Structure

```text
new-musics/
new-musics-previews/

tmp/
├── new-wav/
├── new-wav-prev/
└── xact-project/
```

---

# Workflow

```text
Extract game audio
→ Replace WAV files
→ Generate previews
→ Open XACT automatically
→ Build new XSB/XWB
→ Package mod-output/
```

---

# How to support?

1- Star this github repository

2- Tip me on : [https://ko-fi.com/metasharp](https://ko-fi.com/metasharp)

---

# Requirements

* Windows 10 / 11
* ffmpeg
* unxwb
* Xact3.exe

---

# Included Tools

| Tool   | Role                 |
| ------ | -------------------- |
| ffmpeg | Audio conversion     |
| unxwb  | XWB extraction       |
| Xact3  | XACT project editing |

---

# License

MIT

---

# Suggested Tracklist for the game

* 01 fastway - go beat crazy
* 02 ace - power of sound
* 03 tommy k. - break the night
* 04 max coveri - running in the 90's
* 05 dave rodgers - space boy
* 06 dr. love feat. d. essex - max power
* 07 edo boys - no one sleep in tokyo
* 08 m.o.v.e - dogfight
* 09 niko - night of fire
* 10 mega nrg man - back on the rocks
* 11 ken blast - the top
* 12 dave rodgers - deja vu
* 13 mako & sayuki - wings of fire
* 14 mega nrg man - burning desire
* 15 leslie parrish - save me
* 16 jager - i won't fall apart
* 17 go 2 - looka bomba
* 18 vicky vale - dancing
* 19 sound holic vs eurobeat union feat nana takahashi - no life queen [dj command remix]
* 20 sound holic feat nana takahashi - preserved vampire

---

# Statistics

GitHub Downloads stats : https://grev.shehryar.ae/?owner=MetasharpNet&repo=Initial-D-Arcade-Stage-8-Infinity-BGM-AutoMod
