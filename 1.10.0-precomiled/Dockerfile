FROM debian:stable-slim

LABEL maintainer="Maksym Pugach <pugach.m@gmail.com>"

ENV BITCOIN_ROOT=/dogecore
ENV BITCOIN_DATA="${BITCOIN_ROOT}/data" \
    DOGECOIN_VERSION="1.10.0" \
    DOGECOIN_SHA="2e5b61842695d74ebcd30f21014cf74b6265f0f7756e9f140f031259bb3cd656" \
    PATH="${BITCOIN_ROOT}/bin:$PATH"

RUN mkdir -p $BITCOIN_ROOT && mkdir -p $BITCOIN_DATA

WORKDIR $BITCOIN_ROOT

RUN apt-get update && \
    apt-get -y install curl && \
    apt-get clean

RUN curl -OL "https://github.com/dogecoin/dogecoin/releases/download/v${DOGECOIN_VERSION}/dogecoin-${DOGECOIN_VERSION}-linux64.tar.gz" && \
    echo "${DOGECOIN_SHA}  dogecoin-${DOGECOIN_VERSION}-linux64.tar.gz" | sha256sum -c && \
    tar --strip-components=1 -xzf "dogecoin-${DOGECOIN_VERSION}-linux64.tar.gz" && \
    rm "dogecoin-${DOGECOIN_VERSION}-linux64.tar.gz"

EXPOSE 22555 22556 44555 44556

COPY dogecoin.conf $BITCOIN_ROOT
COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["dogecoind"]
