FROM debian:jessie
MAINTAINER LiXianJing<lixianjing@zlg.cn>

# Set the reset cache variable
ENV REFRESHED_AT 2017-09-03

ENV DEBIAN_FRONTEND noninteractive

# Update packages list
RUN apt-get update -y

# Install useful packages
# RUN apt-get install -y strace procps tree vim git curl wget gnuplot

# Install required software
RUN apt-get install -y git make build-essential libssl-dev

# Install wrk - benchmarking software
# Resource: https://github.com/wg/wrk/wiki/Installing-Wrk-on-Linux
WORKDIR /tmp

# Install Luarocks dependencies
RUN apt-get install -y curl \
                       make \
                       unzip \
                       lua5.1 \
                       liblua5.1-dev

# Install Luarocks - a lua package manager
RUN curl https://keplerproject.github.io/luarocks/releases/luarocks-2.2.2.tar.gz -O &&\
    tar -xzvf luarocks-2.2.2.tar.gz &&\
    cd luarocks-2.2.2 &&\
    ./configure &&\
    make build &&\
    make install

# Install the cjson package
RUN luarocks install lua-cjson

RUN git clone https://github.com/xianjimli/wrk.git &&\
    cd wrk && \
    make && \
    mv wrk /usr/local/bin && \
    cp -rvf scripts /

WORKDIR /

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Raise the limits to successfully run benchmarks
RUN ulimit -c -m -s -t unlimited

ENV DEBIAN_FRONTEND=newt

