FROM alpine:3.8

LABEL maintainer="Maksym Pugach <pugach.m@gmail.com>"

ENV BITCOIN_ROOT=/dogecore
ENV BDB_PREFIX="${BITCOIN_ROOT}/bdb" \
    BDB_SHA="08238e59736d1aacdd47cfb8e68684c695516c37f4fbe1b8267dde58dc3a576c" \
    BDB_VERSION="5.1.29" \
    BITCOIN_DATA="${BITCOIN_ROOT}/data" \
    DOGECOIN_SHA="e392f4142819fdab313ba921af53fdbd2cf6ee8965d237d0cb5cda8a52c97084" \
    DOGECOIN_VERSION="1.10.0" \
    PATH="${BITCOIN_ROOT}/bin:$PATH"

RUN mkdir -p $BITCOIN_ROOT && mkdir -p $BDB_PREFIX

COPY boost_1.66.patch $BITCOIN_ROOT/boost_1.66.patch

WORKDIR $BITCOIN_ROOT

RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl openssl boost libtool boost-dev openssl-dev

RUN apk add --no-cache git autoconf automake g++ make file && \
    wget "https://github.com/dogecoin/dogecoin/archive/v${DOGECOIN_VERSION}.tar.gz" && \
    echo "${DOGECOIN_SHA}  v${DOGECOIN_VERSION}.tar.gz" | sha256sum -c && \
    wget "http://download.oracle.com/berkeley-db/db-${BDB_VERSION}.NC.tar.gz" && \
    echo "${BDB_SHA}  db-${BDB_VERSION}.NC.tar.gz" | sha256sum -c && \
    tar -xzf "db-${BDB_VERSION}.NC.tar.gz" && \
    cd "db-${BDB_VERSION}.NC/build_unix/" && \
    ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$BDB_PREFIX && \
    make -j4 && \
    make install && \
    cd $BITCOIN_ROOT && \
    tar -xzf "v${DOGECOIN_VERSION}.tar.gz" && \
    cd "dogecoin-${DOGECOIN_VERSION}" && \
    git apply "${BITCOIN_ROOT}/boost_1.66.patch" && \
    ./autogen.sh && \
    ./configure \
        LDFLAGS="-L${BDB_PREFIX}/lib/" \
        CPPFLAGS="-I${BDB_PREFIX}/include/" \
        --disable-tests \
        --disable-bench \
        --disable-ccache \
        --with-gui=no \
        --with-utils \
        --with-libs \
        --with-daemon \
        --enable-wallet \
        --prefix=$BITCOIN_ROOT && \
    make -j4 && \
    make install && \
    rm -rf $BDB_PREFIX/docs && \
    rm -rf $BITCOIN_ROOT/db-* && \
    rm -rf $BITCOIN_ROOT/*.tar.gz \
    rm -rf $BITCOIN_ROOT/dogecoin-* \
    strip $BITCOIN_ROOT/bin/dogecoin-cli && \
    strip $BITCOIN_ROOT/bin/dogecoin-tx && \
    strip $BITCOIN_ROOT/bin/dogecoind && \
    strip $BITCOIN_ROOT/lib/libbitcoinconsensus.a && \
    strip $BITCOIN_ROOT/lib/libbitcoinconsensus.so.0.0.0 && \
    apk del git autoconf automake g++ make file

EXPOSE 8332 8333 18332 18333

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["dogecoind"]
