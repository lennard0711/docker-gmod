#!/bin/bash

# Installs the GMod Server
${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir ${STEAM_APP_DIR} +app_update 4020 +quit

# Writes the selected gamemode into the autoexec
echo "gamemode ${GMOD_GAMEMODE}" > ${STEAM_APP_DIR}/garrysmod/cfg/autoexec.cfg