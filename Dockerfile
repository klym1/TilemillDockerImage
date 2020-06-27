FROM ubuntu:18.04 AS MapnikBuilder

ENV MAPNIK_INSTALL_VERSION=3.0.23 \
    CC=/usr/bin/clang \
    CXX=/usr/bin/clang++ \
    LD_LIBRARY_PATH=/usr/local/lib

RUN apt-get update && apt-get install -y \
        build-essential \
        libboost-filesystem-dev \
        libboost-program-options-dev \
        libboost-python-dev libboost-regex-dev \
        libboost-system-dev libboost-thread-dev \
        libicu-dev \
        python3-dev libxml2 libxml2-dev \
        libfreetype6 libfreetype6-dev \
        libharfbuzz-dev \
        libjpeg-dev \
        libpng-dev \
        libproj-dev \
        libtiff-dev \
        clang \
        libcairo2-dev python3-cairo-dev \
        libcairomm-1.0-dev \
        ttf-unifont ttf-dejavu ttf-dejavu-core ttf-dejavu-extra \
        python3-nose \
        libgdal-dev python3-gdal 

RUN apt-get update && apt-get install -y \
        git \
        node-gyp \
        libssl1.0-dev \
        nodejs \
        curl \
        npm \
        nano     
    
WORKDIR /opt
       
RUN git clone -b v${MAPNIK_INSTALL_VERSION} --single-branch --recursive https://github.com/mapnik/mapnik.git
    
WORKDIR /opt/mapnik
RUN ./configure CXX=clang++ CC=clang && \
    make && \
    make install

RUN rm -rf /opt/mapnik

WORKDIR /opt/
RUN git clone https://github.com/tilemill-project/tilemill.git

WORKDIR /opt/tilemill

RUN npm install

COPY config.defaults.json /opt/tilemill/lib/config.defaults.json

WORKDIR /opt/tilemill

ENTRYPOINT ["npm", "start"]
