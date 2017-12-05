ARG PYTHON_VERSION=3.7.4

FROM python:${PYTHON_VERSION}

ENV GDAL_VERSION 2.4.0

RUN set -ex \
    && buildDeps=" \
      g++ \
      gcc \
      make \
      wget \
    " \
    && DEBIAN_FRONTEND=noninteractive apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install -y -qq --no-install-recommends $buildDeps \
    && wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz --output-document=/tmp/gdal.tar.gz \
    && tar --extract --file=/tmp/gdal.tar.gz --directory=/tmp \
    && cd /tmp/gdal-$GDAL_VERSION \
    && ./configure \
      --with-python \
      --with-pg \
      --disable-static \
    && make -j`grep -c ^processor /proc/cpuinfo` \
    && make install \
    && bash -c "strip /usr/local/lib/libgdal.a /usr/local/lib/libgdal.so.*.*.* /usr/local/bin/ogr* /usr/local/bin/gdal* || true" \
    && DEBIAN_FRONTEND=noninteractive apt purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/* /tmp/gdal-$GDAL_VERSION /tmp/gdal.tar.gz
