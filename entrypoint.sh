#!/bin/bash

if [ ${STEAM_API_KEY} = false ] || [ ${STEAM_API_KEY} = "none" ] || [ -z "${STEAM_API_KEY}" ] ; then
    echo 'You need to provide a Steam API Key. Get yours here: https://steamcommunity.com/dev/apikey'
    exit
fi

# Installs CSS and TF2 files if selected
if [ ${GMOD_CSS} = true ] && [ ${GMOD_TF2} = true ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/css +app_update 232330 +quit +force_install_dir /home/steam/tf +app_update 232250 +quit

    echo '"mountcfg"
{
    "cstrike"   "/home/steam/css/cstrike"
    "tf"        "/home/steam/tf/tf"  
}' > ${STEAM_APP_DIR}/garrysmod/cfg/mount.cfg
# Installs CSS files if selected
elif [ ${GMOD_CSS} = true ] && [ ${GMOD_TF2} = false ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/css +app_update 232330 +quit

    echo '"mountcfg"
{
    "cstrike"   "/home/steam/css/cstrike"
//    "tf"        "/home/steam/tf/tf"  
}' > ${STEAM_APP_DIR}/garrysmod/cfg/mount.cfg
# Installs TF2 files if selected
elif [ ${GMOD_CSS} = false ] && [ ${GMOD_TF2} = true ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/tf +app_update 232250 +quit

    echo '"mountcfg"
{
//    "cstrike"   "/home/steam/css/cstrike"
    "tf"        "/home/steam/tf/tf"  
}' > ${STEAM_APP_DIR}/garrysmod/cfg/mount.cfg
fi

# Create the server config 

rm ${STEAM_APP_DIR}/garrysmod/cfg/server.cfg

# Set server variables
for LINE in $(compgen -A variable | grep 'HOSTNAME\|RCON_\|SV_\|NET_\|DECALFREQUENCY')
do
    ENV_NAME=${LINE}
    ENV_VAL=$(printenv ${ENV_NAME})
    CONF_NAME=$(echo ${ENV_NAME} | awk '{print tolower($0)}')
    echo ${CONF_NAME} \"${ENV_VAL}\" >> ${STEAM_APP_DIR}/garrysmod/cfg/server.cfg
done

# Set TTT variables
if [ ${GMOD_GAMEMODE} = "terrortown" ]; then
    for LINE in $(compgen -A variable | grep TTT_)
    do
        ENV_NAME=${LINE}
        ENV_VAL=$(printenv ${ENV_NAME})
        CONF_NAME=$(echo $ENV_NAME | awk '{print tolower($0)}')
        echo $CONF_NAME \"$ENV_VAL\" >> ${STEAM_APP_DIR}/garrysmod/cfg/server.cfg
    done
else
    echo "Other gamemodes than TTT are currently not supported :("
    echo "If you want to add more gamemodes you can create a pull request at: https://github.com/lennard0711/docker-gmod"
    exit
fi

# Start the server
${STEAM_APP_DIR}/srcds_run -maxplayers ${GMOD_PLAYERS} -game garrysmod +gamemode ${GMOD_GAMEMODE} +map ${GMOD_DEFAULT_MAP} -authkey ${STEAM_API_KEY} +host_workshop_collection ${STEAM_COLLECTION}