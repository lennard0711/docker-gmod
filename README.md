ENV STEAM_APP_DIR /home/steam/gm
ENV STEAM_API_KEY false
ENV STEAM_COLLECTION 1297312862

ENV GMOD_GAMEMODE terrortown
ENV GMOD_CSS true
ENV GMOD_TF2 false

if [ ${GMOD_CSS} = true ]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/css +app_update 232330 +quit
fi

if [ ${GMOD_TF2} = true]; then
    ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir /home/steam/tf +app_update 232250 +quit
fi