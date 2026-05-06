#!/usr/bin/env bash
premake5 --file=build-linux-arm64.lua gmake
make clean config=release
make config=release
cp bin/release/libsteamworks4j-arm64.so ../java-wrapper/src/main/resources/libsteamworks4j-arm64.so
cp bin/release/libsteamworks4j-server-arm64.so ../server/src/main/resources/libsteamworks4j-server-arm64.so
cp bin/release/libsteamworks4j-encryptedappticket-arm64.so ../server/src/main/resources/libsteamworks4j-encryptedappticket-arm64.so
