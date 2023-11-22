#!/usr/bin/python3

import struct
import sys
import os
import socket
import ssl
import argparse

# Function to convert received JPEG images to MJPEG stream
def convert_to_mjpeg(img):
    mjpeg_header = b"--boundary\r\nContent-Type: image/jpeg\r\nContent-Length: %d\r\n\r\n" % len(img)
    return mjpeg_header + img + b"\r\n"

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

                # Convert JPEG image to MJPEG stream and write to stdout
                mjpeg_data = convert_to_mjpeg(img)
                os.write(1, mjpeg_data)
