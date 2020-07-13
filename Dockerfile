FROM ubuntu:bionic
MAINTAINER tkoyama010@gmail.com

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV TERM xterm
ENV TAG_NAME=master

USER root
WORKDIR work
RUN apt-get update
# RUN apt-get  -y --no-install-recommends upgrade

# getfem repository

RUN apt-get install -y --no-install-recommends ca-certificates
# RUN apt-get install -y --no-install-recommends git
# RUN git clone https://git.savannah.nongnu.org/git/getfem.git
RUN apt-get install -y --no-install-recommends wget
RUN wget http://download-mirror.savannah.gnu.org/releases/getfem/stable/getfem-5.4.1.tar.gz
RUN tar xzf getfem-5.4.1.tar.gz

# install dependencies

RUN apt-get update
# RUN apt-get install -y --no-install-recommends automake
RUN apt-get install -y --no-install-recommends libtool
RUN apt-get install -y --no-install-recommends make
RUN apt-get install -y --no-install-recommends g++
RUN apt-get install -y --no-install-recommends gfortran
RUN apt-get install -y --no-install-recommends libopenmpi-dev
RUN apt-get install -y --no-install-recommends openmpi-bin
RUN apt-get install -y --no-install-recommends libhdf5-openmpi-dev
RUN apt-get install -y --no-install-recommends libqd-dev
RUN apt-get install -y --no-install-recommends libqhull-dev
RUN apt-get install -y --no-install-recommends libmumps-seq-dev
RUN apt-get install -y --no-install-recommends liblapack-dev
RUN apt-get install -y --no-install-recommends libopenblas-dev
RUN apt-get install -y --no-install-recommends libpython3-dev
# RUN apt-get install -y --no-install-recommends ufraw
# RUN apt-get install -y --no-install-recommends imagemagick
# RUN apt-get install -y --no-install-recommends fig2dev
# RUN apt-get install -y --no-install-recommends texlive
# RUN apt-get install -y --no-install-recommends xzdec
# RUN apt-get install -y --no-install-recommends fig2ps
# RUN apt-get install -y --no-install-recommends gv
RUN apt-get install -y --no-install-recommends python3-pip
RUN apt-get install -y --no-install-recommends python3-venv
# RUN apt-get install -y --no-install-recommends python3-numpy
# RUN apt-get install -y --no-install-recommends python3-scipy
# RUN apt-get install -y --no-install-recommends python3-sphinx
# RUN apt-get install -y --no-install-recommends python3-mpi4py

# compile and install

RUN python3 -m venv /venv
RUN source /venv/bin/activate && \
    cd getfem-5.4.1/ && \
    pip install --no-cache --upgrade pip && \
    pip install numpy scipy sphinx mpi4py && \
#    git checkout $TAG_NAME && \
#    bash autogen.sh && \
    ./configure --prefix=/venv --with-pic && \
    make -j8 && \
    make -j8 check && \
    make install && \
    cd interface && \
    make install && \
    deactivate
RUN rm -rf getfem
RUN echo installed at /venv
