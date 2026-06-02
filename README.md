# Road Fighter — PortMaster Port

A PortMaster port of [Road Fighter](https://github.com/reybits/road-fighter), the SDL1.2 remake of the classic 1984 Konami arcade racer, targeting ARM64 handhelds running [PortMaster](https://portmaster.games/).

This repo is a fork of [reybits/road-fighter](https://github.com/reybits/road-fighter), itself a refactor of the original remake by Brain Games (Santi Ontanon), created for the 2003 Retro Remakes competition.

---

## PortMaster Patches

The following fixes were applied on top of the upstream reybits source to make the game run correctly on PortMaster devices:

- **Force fullscreen** — `fullscreen` defaults to `false` on non-Windows in the upstream source; patched to `true` for PortMaster.
- **Remove `pause(1000)`** — a 1-second busy-wait in `initializeSDL()` caused a crash on ARM devices; removed.
- **Credits scroll speed** — `menu_credits_timmer += 2` was incremented in `menu_draw()` (called every render frame), causing credits to scroll too fast; moved to `menu_cycle()` (called at 35 fps).
- **`MESA_SHADER_CACHE_DISABLE=true`** — prevents a SEGV_ACCERR crash in Mesa/Freedreno shader cache on Adreno 6xx GPUs (e.g. Snapdragon 865 on Retroid Pocket 5 running Rocknix).

---

## Building

### Requirements

A Linux x86_64 host with Docker and ARM64 emulation support.

**Ubuntu / Debian:**
```bash
sudo apt install docker.io qemu-user-static binfmt-support
sudo systemctl start docker
```

**Fedora / RHEL:**
```bash
sudo dnf install docker qemu-user-static
sudo systemctl restart systemd-binfmt
sudo systemctl start docker
```

### Build

```bash
git clone https://github.com/lilian-pfister/roadfighter-portmaster.git
cd roadfighter-portmaster
./build.sh
```

This will:
1. Build a Docker image (`--platform linux/arm64`) with all SDL dependencies
2. Cross-compile the game binary for ARM64
3. Extract the required SDL `.so` files from the Docker image
4. Package everything into `roadfighter.zip` via CPack

### Output

`roadfighter.zip` — a PortMaster-ready package containing:

```
roadfighter.sh          ← launch script (goes in /roms/ports/)
roadfighter/
  roadfighter.aarch64   ← compiled binary
  assets/               ← graphics, sounds, fonts, maps
  libs.aarch64/         ← bundled SDL satellite libraries
  roadfighter.gptk      ← controller mapping
  port.json             ← PortMaster metadata
  screenshot.png
```

### Installing on device

**Via SSH:**
```bash
scp roadfighter.zip user@<device-ip>:/roms/ports/
ssh user@<device-ip> "cd /roms/ports && unzip roadfighter.zip"
```

**Via PortMaster:**
Copy `roadfighter.zip` to the SD card and use PortMaster's "Install from zip" option.

---

## Credits

- **Original remake**: Santi Ontanon (Brain Games), 2003
- **Refactor & CMake port**: Andrey A. Ugolnik ([reybits/road-fighter](https://github.com/reybits/road-fighter))
- **PortMaster port**: Lilian Pfister
