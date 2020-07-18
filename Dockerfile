FROM cm2network/steamcmd:root

LABEL maintainer="Lennard Indlekofer <info@lennard0711.com>"

ENV STEAM_HOME_DIR /home/steam
ENV STEAM_APP_DIR /home/steam/gm
ENV STEAM_CMD_DIR /home/steam/steamcmd
ENV STEAM_API_KEY false
ENV STEAM_COLLECTION 1297312862

ENV GMOD_GAMEMODE terrortown
ENV GMOD_CSS false
ENV GMOD_TF2 false
ENV GMOD_DEFAULT_MAP gm_construct
ENV GMOD_PLAYERS 16

ADD entrypoint.sh ${STEAM_HOME_DIR}/entrypoint.sh

RUN set -x \
    && chmod 755 ${STEAM_HOME_DIR}/entrypoint.sh \
    && chown -R steam:steam ${STEAM_HOME_DIR}

USER steam
RUN set -x \
    && ${STEAM_CMD_DIR}/steamcmd.sh +login anonymous +force_install_dir ${STEAM_APP_DIR} +app_update 4020 +quit \
    && echo "gamemode ${GMOD_GAMEMODE}" > ${STEAM_APP_DIR}/garrysmod/cfg/autoexec.cfg

EXPOSE 27015/tcp 27015/udp

ENV HOSTNAME "lennard0711 dockerized GMod Server"
ENV RCON_PASSWORD changeme
ENV SV_LOGBANS 1
ENV SV_LOGECHO 1
ENV SV_LOGFILE 1
ENV SV_LOG_ONEFILE 0
ENV NET_MAXFILESIZE 60
ENV SV_MINRATE 3500
ENV SV_MAXRATE 0
ENV DECALFREQUENCY 10
ENV SV_MAXUPDATERATE 33
ENV SV_MINUPDATERATE 10

WORKDIR ${STEAM_HOME_DIR}
ENTRYPOINT ["./entrypoint.sh"]