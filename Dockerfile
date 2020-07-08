FROM cm2network/steamcmd:root

LABEL maintainer="Lennard Indlekofer <info@lennard7001.com>"

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

ADD install.sh ${STEAM_HOME_DIR}/install.sh
ADD server-cfg.sh ${STEAM_HOME_DIR}/server-cfg.sh
ADD entrypoint.sh ${STEAM_HOME_DIR}/entrypoint.sh

RUN set -x \
    && chmod 755 ${STEAM_HOME_DIR}/install.sh \
    && chmod 755 ${STEAM_HOME_DIR}/server-cfg.sh \
    && chmod 755 ${STEAM_HOME_DIR}/entrypoint.sh \
    && chown -R steam:steam ${STEAM_HOME_DIR}

USER steam
RUN /home/steam/install.sh

EXPOSE 27015/tcp 27015/udp

WORKDIR ${STEAM_HOME_DIR}
ENTRYPOINT ["./entrypoint.sh"]