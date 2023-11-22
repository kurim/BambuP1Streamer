#!/usr/bin/python3

import struct
import os
import socket
import ssl
import argparse
import cv2
import numpy as np
import subprocess
from pyvirtualdisplay import Display

# Function to convert received JPEG images to MJPEG stream
def convert_to_mjpeg(img):
    mjpeg_header = b"--boundary\r\nContent-Type: image/jpeg\r\nContent-Length: %d\r\n\r\n" % len(img)
    return mjpeg_header + img + b"\r\n"

# Function to convert MJPEG frames to H.264 video using OpenCV and FFmpeg
def convert_to_h264(mjpeg_data):
    img = cv2.imdecode(np.frombuffer(mjpeg_data, dtype=np.uint8), cv2.IMREAD_COLOR)
    return img if img is not None else np.zeros((480, 640, 3), dtype=np.uint8)

# Parse command-line arguments
parser = argparse.ArgumentParser(description='P1 Streamer')
parser.add_argument('-a', '--access-code', help='Printer Access code', required=True)
parser.add_argument('-i', '--ip', help='Printer IP Address', required=True)
args = parser.parse_args()

username = 'bblp'
access_code = args.access_code
hostname = args.ip
port = 6000

d = bytearray()
d += struct.pack("IIL", 0x40, 0x3000, 0x0)
for i in range(0, len(username)):
    d += struct.pack("<c", username[i].encode('ascii'))
for i in range(0, 32 - len(username)):
    d += struct.pack("<x")
for i in range(0, len(access_code)):
    d += struct.pack("<c", access_code[i].encode('ascii'))
for i in range(0, 32 - len(access_code)):
    d += struct.pack("<x")

ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

jpeg_start = "ff d8 ff e0"
jpeg_end = "ff d9"
read_chunk_size = 2048
boundary = b"BambuP1"

with Display():
    for i in range(5):  # Assuming you want to process 5 frames for demonstration
        with socket.create_connection((hostname, port)) as sock:
            with ctx.wrap_socket(sock, server_hostname=hostname) as ssock:
                ssock.write(d)
                buf = bytearray()
                start = False
                while True:
                    dr = ssock.recv(read_chunk_size)
                    if not dr:
                        break

                    buf += dr

                    if not start:
                        i = buf.find(bytearray.fromhex(jpeg_start))
                        if i >= 0:
                            start = True
                            buf = buf[i:]
                        continue

                    i = buf.find(bytearray.fromhex(jpeg_end))
                    if i >= 0:
                        img = buf[:i + len(jpeg_end)]
                        buf = buf[i + len(jpeg_end):]
                        start = False

                        # Convert JPEG image to MJPEG stream
                        mjpeg_data = convert_to_mjpeg(img)

                        # Convert MJPEG to H.264 using OpenCV
                        frame = convert_to_h264(mjpeg_data)

                        # If you want to save the H.264 frames to a video file using FFmpeg
                        # Replace 'output.mp4' with the desired filename
                        filename = f'output_{i}.mp4'
                        out = cv2.VideoWriter(filename, cv2.VideoWriter_fourcc(*'avc1'), 30.0, (frame.shape[1], frame.shape[0]))
                        out.write(frame)
                        out.release()

                        # Stream the generated video file using FFmpeg
                        ffmpeg_command = ['ffmpeg', '-re', '-i', filename, '-c', 'copy', '-f', 'mpegts', f'udp://{hostname}:{port}']
                        subprocess.Popen(ffmpeg_command)

                        # Remove the video file after streaming
                        os.remove(filename)

cv2.destroyAllWindows()  # Close OpenCV windows after processing frames
