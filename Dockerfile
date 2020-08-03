FROM docker.io/vshn/modulesync:1.3.0

LABEL maintainer="VSHN AG <tech@vshn.ch>"

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      openssh-client \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ln -sv /opt/concierge.sh /usr/local/bin/concierge

COPY entrypoint.sh concierge.sh /opt/
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["concierge"]

USER msync
RUN mkdir -m 700 -p ~/.ssh \
 && touch ~/.ssh/known_hosts \
 && chmod 644 ~/.ssh/known_hosts
