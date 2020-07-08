#!/bin/bash

if [ ${STEAM_API_KEY} = false ]; then
    echo 'You need to provide a Steam API Key. Get yours here: https://steamcommunity.com/dev/apikey'
    exit
fi

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

${STEAM_HOME_DIR}/server-cfg.sh

# Start Server
${STEAM_APP_DIR}/srcds_run -maxplayers ${GMOD_PLAYERS} -game garrysmod +gamemode ${GMOD_GAMEMODE} +map ${GMOD_DEFAULT_MAP} -authkey ${STEAM_API_KEY} +host_workshop_collection ${STEAM_COLLECTION}