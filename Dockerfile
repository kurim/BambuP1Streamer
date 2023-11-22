# Main-Image
FROM alexxit/go2rtc:latest

# Update packages and install necessary dependencies
RUN apk update && apk add wget curl ffmpeg

RUN mkdir -p /app
COPY go2rtc.yaml p1.py p1-test.py /app/

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

EXPOSE 8554
CMD ["go2rtc"]
