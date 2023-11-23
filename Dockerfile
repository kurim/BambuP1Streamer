# Main-Image
FROM alexxit/go2rtc:latest

# Update packages and install necessary dependencies
RUN apk update && apk add wget curl

RUN mkdir -p /app
COPY go2rtc.yaml p1.py /app/

# Set environment variables if needed
ENV PRINTER_ADDRESS=
ENV PRINTER_ACCESS_CODE=
ENV UI_USERNAME=
ENV UI_PASSWORD=
ENV RTSP_USERNAME=
ENV RTSP_PASSWORD=

# Expose necessary ports
EXPOSE 8554

# Set working directory
WORKDIR /app

LABEL \
  io.hass.version="VERSION" \
  io.hass.type="addon" \
  io.hass.arch="aarch64|amd64"

CMD ["go2rtc"]
