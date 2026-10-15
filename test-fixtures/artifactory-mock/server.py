"""Minimal stand-in for Artifactory's deploy API, used by ci.yml.

PUT /artifactory/<repo>/<path>;key=value;... stores the body under ROOT and
records the matrix-param properties. Like the real server, it rejects a
wrong Bearer token (401) and a body that doesn't match X-Checksum-Sha256 (409).

Usage: python3 server.py <port> <root-dir> <token>
"""
import hashlib
import json
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from urllib.parse import unquote

PORT, ROOT, TOKEN = int(sys.argv[1]), Path(sys.argv[2]), sys.argv[3]
PREFIX = "/artifactory/"


class Handler(BaseHTTPRequestHandler):
    def do_PUT(self):
        if self.headers.get("Authorization") != f"Bearer {TOKEN}":
            return self.reply(401, "bad token")
        if not self.path.startswith(PREFIX):
            return self.reply(404, "not found")

        path, *params = self.path[len(PREFIX):].split(";")
        body = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        if hashlib.sha256(body).hexdigest() != self.headers.get("X-Checksum-Sha256"):
            return self.reply(409, "checksum mismatch")

        dest = ROOT / unquote(path)
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(body)
        props = dict(unquote(p).split("=", 1) for p in params)
        dest.with_name(dest.name + ".properties.json").write_text(json.dumps(props))
        self.reply(201, json.dumps({"path": unquote(path)}))

    def reply(self, code, text):
        self.send_response(code)
        self.end_headers()
        self.wfile.write(text.encode())


HTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
