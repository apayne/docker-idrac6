FROM jlesage/baseimage-gui:alpine-3.11

ENV APP_NAME="iDRAC 6" \
    IDRAC_USER="" \
    IDRAC_PASSWORD="" \
    IDRAC_PORT=443 \
    USER_ID="nobody" \
    GROUP_ID="nobody"

COPY keycode-hack.c /keycode-hack.c

# --- refresh packages and build
RUN apk update && \
    apk upgrade && \
    apk add build-base libx11-dev && \
    gcc -o /keycode-hack.so /keycode-hack.c -shared -s -ldl -fPIC && \
    apk del --purge build-base libx11-dev && \
    apk update --repository edge && \
    apk add --repository edge openjdk7-jre wget dash


RUN mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app

COPY startapp.sh /startapp.sh

WORKDIR /app
