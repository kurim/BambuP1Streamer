#!/usr/bin/env bashio
# shellcheck shell=bash

CONFIG_PATH=/data/options.json

PRINTER_ADDRESS="$(bashio::config 'PRINTER_ADDRESS')"
PRINTER_ACCESS_CODE="$(bashio::config 'PRINTER_ACCESS_CODE')"
UI_USERNAME="$(bashio::config 'UI_USERNAME')"
UI_PASSWORD="$(bashio::config 'UI_PASSWORD')"
RTSP_USERNAME="$(bashio::config 'RTSP_USERNAME')"
RTSP_PASSWORD="$(bashio::config 'RTSP_PASSWORD')"

bashio::log.info 'Start go2rtc'
bashio::log.info $(bashio::info.hostname)
bashio::log.info $(bashio::info.arch)
./go2rtc
bashio::log.info 'Stop go2rtc'
