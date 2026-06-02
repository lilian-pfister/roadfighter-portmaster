#!/bin/bash
# Road Fighter - PortMaster launch script
# Source: https://github.com/lilian-pfister/roadfighter-portmaster
# Original game by Brain Games (Santi Ontanon), refactored by Andrey A. Ugolnik
# Ported to PortMaster/ARM64 by: Lilian Pfister

# ── PortMaster boilerplate ────────────────────────────────────────────────────
if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source "$controlfolder/control.txt"
get_controls

# ── Port variables ────────────────────────────────────────────────────────────
SCRIPTDIR="$(cd "$(dirname "$0")" && pwd)"
GAMEDIR="$SCRIPTDIR/roadfighter"

[ -z "$DEVICE_ARCH" ] && DEVICE_ARCH="$(uname -m)"

# ── Architecture-specific libs ────────────────────────────────────────────────
export LD_LIBRARY_PATH="$GAMEDIR/libs.${DEVICE_ARCH}:$LD_LIBRARY_PATH"

# SDL 1.2 compat configuration (maps SDL1 calls → SDL2)
export SDL12COMPAT_USE_GAME_CONTROLLERS=1
export SDL12COMPAT_SCALE_METHOD=nearest

# Prevent Mesa/Freedreno shader cache crash on Adreno 6xx (Snapdragon 865)
export MESA_SHADER_CACHE_DISABLE=true

# ── Save / config location ────────────────────────────────────────────────────
CONFDIR="${USERDATA:-$HOME/.config}/roadfighter"
mkdir -p "$CONFDIR"
type bind_directories &>/dev/null && bind_directories ~/.roadfighter "$CONFDIR"

# ── Controller mapping ────────────────────────────────────────────────────────
if [ -n "$GPTOKEYB" ]; then
  $GPTOKEYB "roadfighter.${DEVICE_ARCH}" -c "$GAMEDIR/roadfighter.gptk" &
fi

# ── SDL controller config ─────────────────────────────────────────────────────
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

# ── Change to game directory and run ─────────────────────────────────────────
cd "$GAMEDIR"
./roadfighter.${DEVICE_ARCH}

# ── Cleanup ───────────────────────────────────────────────────────────────────
kill -9 "$(pidof gptokeyb)" 2>/dev/null || true
