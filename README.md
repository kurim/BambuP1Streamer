# Bambu P1 Camera Streamer

Only tested on a P1S.

Based on go2rtc Docker

# DEPENDENCIES

* [Go2Rtc](https://github.com/AlexxIT/go2rtc/)
* wget unzip curl

## Info

Folder /ha Contains Homeassistant Docker Config

# BUILD

## build container
```
docker build -t p1stream .
```

# RUN

## Docker (local)
```
docker run -d --name p1stream -p 1984:1984 -p 8554:8554 \
-e PRINTER_ADDRESS=<PrinterIP> -e PRINTER_ACCESS_CODE=12345678 \
-e UI_USERNAME=<UI_USERNAME> -e UI_PASS=<UI_PASS> \
-e RTSP_USERNAME=<RTSP_USERNAME> -e RTSP_PASSWORD=<RTSP_PASSWORD> \
p1stream
```
Port: 1984 Basic API UI
Port: 8554 for RTSP Stream

## Docker compose with Wireguard
Run with docker compose in combination with wireguard.
Download: docker-compose.yml and ip.env

Input the needed data:
```yml
environment:
  - WIREGUARD_PUBLIC_KEY=
  - WIREGUARD_PRIVATE_KEY=
  - WIREGUARD_PRESHARED_KEY=
  - WIREGUARD_ADDRESSES=
  - VPN_ENDPOINT_IP=
  - VPN_ENDPOINT_PORT=
...
environment:
  PRINTER_ADDRESS: 
  PRINTER_ACCESS_CODE: 
  UI_USERNAME: 
  UI_PASSWORD: 
  RTSP_USERNAME: 
  RTSP_PASSWORD: 
```


# ACCESS
###Index Page (only the MJPEG parts will work)
```
http://<host>:1984/links.html?src=p1
```

### MJPEG Streamurl
```
http://<host>:1984/api/stream.mjpeg?src=p1
```
### RTSP Streamurl
```
rtsp://<user>:<pw>@<host>:8554/p1
```
