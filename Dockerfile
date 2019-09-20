FROM docker.io/vshn/modulesync:1.0.0

LABEL maintainer="VSHN AG <tech@vshn.ch>"

USER root
RUN apt-get update \
 && apt-get install -y openssh-client \
 && apt-get clean \
 && ln -sv /opt/concierge.sh /usr/local/bin/concierge

COPY entrypoint.sh concierge.sh /opt/
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["concierge"]

USER msync
RUN mkdir -m 700 -p ~/.ssh \
 && touch ~/.ssh/known_hosts \
 && chmod 644 ~/.ssh/known_hosts
