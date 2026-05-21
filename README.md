# Initial D Arcade Stage 8 Infinity BGM Modder

> Semi-automated custom soundtrack modding workflow for Initial D Arcade Stage 8 Infinity.

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

# Statistics

GitHub Downloads stats : [https://hanadigital.github.io/grev/?user=MetasharpNet&repo=InitialDArcadeStage8InfinityBGMModder](https://hanadigital.github.io/grev/?user=MetasharpNet&repo=Initial-D-Arcade-Stage-8-Infinity-BGM-AutoMod)
