#!/usr/bin/env python3
"""
Small HTTP server that ensures .glb and common image types are served with proper MIME types.
Run: python serve.py 8000
"""
import http.server
import socketserver
import mimetypes
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000

# Ensure common types
mimetypes.add_type('model/gltf-binary', '.glb')
mimetypes.add_type('image/png', '.png')
mimetypes.add_type('image/jpeg', '.jpg')
mimetypes.add_type('image/jpeg', '.jpeg')

Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving HTTP on 0.0.0.0 port {PORT} (http://localhost:{PORT}/) ...")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print('\nShutting down server')
        httpd.server_close()
