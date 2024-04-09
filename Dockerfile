FROM alpine

RUN apk update && apk upgrade

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
