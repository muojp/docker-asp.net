#!/bin/bash

cd /usr/local/src
git clone https://github.com/joyent/libuv.git
cd libuv
git checkout v1.0.0-rc2
sh autogen.sh && ./configure && make && make install
ldconfig
