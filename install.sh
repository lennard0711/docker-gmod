#!/bin/bash

# Installs the GMod Server
${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir ${STEAM_APP_DIR} +app_update 4020 +quit


# Installs the CSS and TF2 files if selected
if [ ${GMOD_CSS} = true ] && [ ${GMOD_TF2} = true ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/css +app_update 232330 +quit +force_install_dir /home/steam/tf +app_update 232250 +quit

    echo '"mountcfg"
{
    "cstrike"   "/home/steam/css/cstrike"
    "tf"        "/home/steam/tf/tf"  
}' > $STEAM_APP_DIR/garrysmod/cfg/mount.cfg
fi

# Installs the CSS files if selected
if [ ${GMOD_CSS} = true ] && [ ${GMOD_TF2} = false ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/css +app_update 232330 +quit

    echo '"mountcfg"
{
    "cstrike"   "/home/steam/css/cstrike"
//    "tf"        "/home/steam/tf/tf"  
}' > $STEAM_APP_DIR/garrysmod/cfg/mount.cfg
fi

# Installs the TF2 files if selected
if [ ${GMOD_CSS} = false ] && [ ${GMOD_TF2} = true ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/tf +app_update 232250 +quit

    echo '"mountcfg"
{
//    "cstrike"   "/home/steam/css/cstrike"
    "tf"        "/home/steam/tf/tf"  
}' > $STEAM_APP_DIR/garrysmod/cfg/mount.cfg
fi

# Writes the selected gamemode into the autoexec
echo "gamemode ${GMOD_GAMEMODE}" > ${STEAM_APP_DIR}/garrysmod/cfg/autoexec.cfg