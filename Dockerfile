FROM alpine:3.9
MAINTAINER James Hunt <james@huntprod.com>

RUN apk add iptables
ADD init /init
ENTRYPOINT ["/init"]
