FROM cm2network/steamcmd:root

LABEL maintainer="Lennard Indlekofer <info@lennard7001.com>"

ENV STEAM_HOME_DIR /home/steam
ENV STEAM_APP_DIR /home/steam/gm
ENV STEAM_CMD_DIR /home/steam/steamcmd
ENV STEAM_API_KEY false
ENV STEAM_COLLECTION 1297312862

ENV GMOD_GAMEMODE terrortown
ENV GMOD_CSS true
ENV GMOD_TF2 false

ADD install.sh ${STEAM_HOME_DIR}/install.sh
ADD entrypoint.sh ${STEAM_APP_DIR}/entrypoint.sh

RUN set -x \
    && chmod 755 ${STEAM_HOME_DIR}/install.sh \
    && chmod 755 ${STEAM_APP_DIR}/entrypoint.sh \
    && chown -R steam:steam ${STEAM_HOME_DIR}

USER steam
CMD [ "/home/steam/gm/install.sh" ]

VOLUME $STEAM_APP_DIR

EXPOSE 27015/tcp 27015/udp