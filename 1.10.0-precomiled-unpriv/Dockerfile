FROM debian:stable-slim

LABEL maintainer="Maksym Pugach <pugach.m@gmail.com>"

ENV BITCOIN_ROOT=/dogecore
ENV BITCOIN_DATA="${BITCOIN_ROOT}/data" \
    DOGECOIN_VERSION="1.10.0" \
    DOGECOIN_SHA="2e5b61842695d74ebcd30f21014cf74b6265f0f7756e9f140f031259bb3cd656" \
    GOSU_VERSION="1.10" \
    PATH="${BITCOIN_ROOT}/bin:$PATH"

RUN mkdir -p $BITCOIN_ROOT && mkdir -p $BITCOIN_DATA

WORKDIR $BITCOIN_ROOT

RUN useradd -r doge \
 && apt-get update -y \
 && apt-get install -y curl gnupg \
 && gpg --keyserver pgp.mit.edu --recv-keys "B42F6819007F00F88E364FD4036A9C25BF357DD4" \
 || gpg --keyserver keyserver.pgp.com --recv-keys "B42F6819007F00F88E364FD4036A9C25BF357DD4" \
 || gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "B42F6819007F00F88E364FD4036A9C25BF357DD4" \
 || gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "B42F6819007F00F88E364FD4036A9C25BF357DD4" \
 && curl -OfSL https://github.com/dogecoin/dogecoin/releases/download/v${DOGECOIN_VERSION}/dogecoin-${DOGECOIN_VERSION}-linux64.tar.gz \
 && echo "${DOGECOIN_SHA}  dogecoin-${DOGECOIN_VERSION}-linux64.tar.gz" | sha256sum -c \
 && tar --strip-components=1 -xzf "dogecoin-${DOGECOIN_VERSION}-linux64.tar.gz" \
 && rm -rf share/ "dogecoin-${DOGECOIN_VERSION}-linux64.tar.gz" \
 && curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
 && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
 && gpg --verify /usr/local/bin/gosu.asc \
 && rm /usr/local/bin/gosu.asc \
 && apt-get purge gnupg -y \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && chmod +x /usr/local/bin/gosu

EXPOSE 22555 22556 44555 44556

COPY dogecoin.conf $BITCOIN_ROOT
COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["dogecoind"]
