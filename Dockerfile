# Author : Steven Beale
# Contact : steven.beale@woodplc.com
# Docker file to build python/R data-science platform on top of ubtuntu 18.04

FROM ubuntu:18.04
RUN apt-get update && apt-get -y install \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    libhdf5-dev \
    libnetcdf-dev \ 
    python3-dev \
    swig \
    wget \
    python3-pip \
    python3-skimage \
    python3-pyproj
# r (actually the dependency tzdata) will ask for your timezone. Suppress it and link localtime to UTC.
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install tzdata
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Now install R
RUN apt-get -y install \
    r-base-dev \
    r-base

# update pip and install python packages
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir setuptools --upgrade

RUN pip3 install --no-cache-dir \
    numpy \
    scipy \
    sympy \
    matplotlib \
    netcdf4 \
    pandas \
    sklearn \
    scikit-image \
    pandas2sklearn \
    pyresample \
    requests \
    awscli \
    boto3 \
    Pillow \
    metpy 

ENV LD_LIBRARY_PATH "/usr/lib"

# Proj4 Installation
RUN wget http://download.osgeo.org/proj/proj-5.0.0.tar.gz \
        && tar xf proj-5.0.0.tar.gz \
        && cd proj-5.0.0 \
        && ./configure --prefix=/usr \
        && make -j4 \
        && make install \
        && cd .. \
        && rm -rf proj-5.0.0 \
        && rm proj-5.0.0.tar.gz

# Basemap
RUN wget https://github.com/matplotlib/basemap/archive/v1.1.0.tar.gz \
        && tar xf v1.1.0.tar.gz \
        && cd basemap-1.1.0/geos-3.3.3 \
        && ./configure --prefix=/usr \
        && make -j4 \
        && make install \
        && cd ../ \
        && python setup.py install \
        && cd / \
        && rm -rf basemap-1.1.0

