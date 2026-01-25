FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    build-essential \
    wget \
    patch \
    unzip \
    cu \
    lrzsz \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ersli-osdev && usermod -aG dialout ersli-osdev
USER ersli-osdev
WORKDIR /home/ersli-osdev

RUN mkdir -p /home/ersli-osdev/.local/src /home/ersli-osdev/.local/bin
ENV PATH="/home/ersli-osdev/.local/bin:${PATH}"

WORKDIR /home/ersli-osdev/.local/src
RUN wget https://kozos.jp/books/makeos/binutils-2.21.tar.gz \
    && tar xf binutils-2.21.tar.gz \
    && cd binutils-2.21 \
    && ./configure --target=h8300-elf --disable-nls --disable-werror --prefix=/home/ersli-osdev/.local \
    && make && make install

WORKDIR /home/ersli-osdev/.local/src
RUN wget https://kozos.jp/books/makeos/gcc-3.4.6.tar.gz \
    && tar xf gcc-3.4.6.tar.gz \
    && cd gcc-3.4.6 \
    && wget -O- https://kozos.jp/books/makeos/patch-gcc-3.4.6-gcc4.txt | patch -p0 \
    && wget -O- https://kozos.jp/books/makeos/patch-gcc-3.4.6-x64-h8300.txt | patch -p0 \
    && ./configure --target=h8300-elf --disable-nls --disable-threads --disable-shared --enable-languages=c --prefix=/home/ersli-osdev/.local \
    && make && make install

WORKDIR /home/ersli-osdev/.local/src
RUN wget https://cubeatsystems.com/kz_h8write/resources/kz_h8write-v0.2.1.zip \
    && unzip kz_h8write-v0.2.1.zip -d kz_h8write \
    && cd kz_h8write/PackageFiles/src \
    && make \
    && cp kz_h8write /home/ersli-osdev/.local/bin/

RUN mkdir -p /home/ersli-osdev/repo
WORKDIR /home/ersli-osdev/repo
