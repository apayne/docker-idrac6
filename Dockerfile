FROM alpine:latest

ENV APP_NAME="iDRAC 6" \
    IDRAC_PORT=443 \
    USER_ID="nobody" \
    GROUP_ID="nobody"

# --- refresh to current packages
RUN apk update && \
    apk upgrade && \
    apk add build-base libx11-dev

# --- build the keycode-hack shim
COPY keycode-hack.c /keycode-hack.c
RUN gcc -o /keycode-hack.so /keycode-hack.c -shared -s -ldl -fPIC

# --- clean up the prior build and prep Java 7 for use
RUN apk del build-base libx11-dev && \
    apk update --repository edge && \
    apk add --repository edge openjdk7-jre wget

RUN mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app


COPY startapp.sh /startapp.sh


WORKDIR /app
