FROM alpine:3.2
MAINTAINER tob@butter.sh

ENV GOGS_VERSION 0.7.33
ENV GOGS_CUSTOM /data/gogs
ENV MY_UID 1000
ENV MY_HOME /data/git
ADD build.sh /tmp/

# Install system utils & Gogs runtime dependencies
RUN echo "@community http://dl-4.alpinelinux.org/alpine/edge/community" \
  | tee -a /etc/apk/repositories \
 && apk -U --no-progress upgrade \
 && apk -U --no-progress add bash ca-certificates curl gettext git linux-pam openssh \
 && /tmp/build.sh \
 && mkdir -p ${MY_HOME} \
 && adduser -u ${MY_UID} -H -D -g 'Gogs Git User' git -h ${MY_HOME} -s /bin/bash \
 && passwd -u git \
 && chmod -R 0777 /data /app \
 && chown -R git:git /data \
 && chmod 0777 /var/run

ADD gogs.sh opensshd.sh app.ini.template app.ini.defaults sshd_config /app/gogs/openshift/

USER git

VOLUME ["/data"]
EXPOSE 22 80