FROM cm2network/steamcmd:root

LABEL maintainer="Lennard Indlekofer <info@lennard7001.com>"

ENV STEAM_APP_DIR /home/steam/gm
ENV STEAM_CMD_DIR /home/steam/steamcmd
ENV STEAM_API_KEY false
ENV STEAM_COLLECTION 1297312862

ENV GMOD_GAMEMODE terrortown
ENV GMOD_CSS true
ENV GMOD_TF2 false

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.20.1-1.1 \
		ca-certificates=20190110 \
	&& mkdir -p ${STEAM_APP_DIR}/gm \
    && cd ${STEAM_APP_DIR} \
    && wget https://raw.githubusercontent.com/lennard7001/docker-gmod/master/install.sh \
    && chmod 755 ${STEAM_APP_DIR}/install.sh \
    && wget https://raw.githubusercontent.com/lennard7001/docker-gmod/master/entrypoint.sh \
    && chmod 755 ${STEAM_APP_DIR}/entrypoint.sh \
    && chown -R steam:steam ${STEAM_APP_DIR} \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

CMD [ "/home/steam/gm/install.sh" ]

USER steam

VOLUME $STEAM_APP_DIR

EXPOSE 27015/tcp 27015/udp