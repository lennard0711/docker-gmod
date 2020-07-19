#!/usr/bin/env bash

# Checks if the Steam Web API key is set
if [ ${STEAM_API_KEY} = false ] || [ ${STEAM_API_KEY} = "none" ] || [ -z "${STEAM_API_KEY}" ] ; then
    echo 'You need to provide a Steam API key. Get yours here: https://steamcommunity.com/dev/apikey'
    exit
fi

# Checks if you want to install CSS or TF2 Files and mounts them
if [ ${GMOD_CSS} = true ] && [ ${GMOD_TF2} = true ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/css +app_update 232330 +force_install_dir /home/steam/tf +app_update 232250 +quit
    echo '"mountcfg"
{
    "cstrike"   "/home/steam/css/cstrike"
    "tf"        "/home/steam/tf/tf"  
}' > ${STEAM_APP_DIR}/garrysmod/cfg/mount.cfg
elif [ ${GMOD_CSS} = true ] && [ ${GMOD_TF2} = false ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/css +app_update 232330 +quit
    echo '"mountcfg"
{
    "cstrike"   "/home/steam/css/cstrike"
//    "tf"        "/home/steam/tf/tf"  
}' > ${STEAM_APP_DIR}/garrysmod/cfg/mount.cfg
elif [ ${GMOD_CSS} = false ] && [ ${GMOD_TF2} = true ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/tf +app_update 232250 +quit
    echo '"mountcfg"
{
//    "cstrike"   "/home/steam/css/cstrike"
    "tf"        "/home/steam/tf/tf"  
}' > ${STEAM_APP_DIR}/garrysmod/cfg/mount.cfg
fi

# Check if you want to create a config
if [ ${GMOD_NO_CONF} = false ] || [ -z "${GMOD_NO_CONF}" ]; then
    # Delete the previous config
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
        echo "If you want to add more gamemodes you can create a pull request or open an issue at: https://github.com/lennard0711/docker-gmod"
        exit
    fi
else
    echo "No config will be created!"
fi

# Start the server
${STEAM_APP_DIR}/srcds_run -maxplayers ${GMOD_PLAYERS} -game garrysmod +gamemode ${GMOD_GAMEMODE} +map ${GMOD_DEFAULT_MAP} -authkey ${STEAM_API_KEY} +host_workshop_collection ${STEAM_COLLECTION}