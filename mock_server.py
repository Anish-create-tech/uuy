from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import random
import time

HOST = '127.0.0.1'
PORT = 8000

# Base sample arrays (12 months)
BASE_FLOW = [40, 50, 65, 120, 300, 500, 600, 550, 350, 150, 70, 45]
BASE_DO =   [6.5, 6.0, 5.5, 5.0, 4.5, 3.5, 1.8, 2.5, 3.8, 4.7, 5.6, 6.3]
BASE_BOD =  [3.5, 3.8, 4.2, 6.0, 12.0, 20.0, 38.0, 30.0, 14.0, 8.0, 5.0, 4.0]
BASE_AMM =  [4.0, 4.2, 4.5, 5.0, 6.0, 7.0, 7.0, 6.5, 5.0, 4.5, 4.2, 4.0]

class Handler(BaseHTTPRequestHandler):
    def _set_headers(self, status=200):
        self.send_response(status)
        self.send_header('Content-type', 'application/json')
        # Allow cross-origin requests for local testing
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cache-Control', 'no-store')
        self.end_headers()

    def do_OPTIONS(self):
        # Respond to CORS preflight
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def do_GET(self):
        if self.path.startswith('/api/river'):
            # Introduce light randomness so the graph changes on refresh
            flow = [max(0, round(v + random.uniform(-10, 10), 2)) for v in BASE_FLOW]
            doVals = [round(max(0, v + random.uniform(-0.5, 0.5)), 2) for v in BASE_DO]
            bodVals = [round(max(0, v + random.uniform(-2.0, 2.0)), 2) for v in BASE_BOD]
            ammVals = [round(max(0, v + random.uniform(-0.5, 0.5)), 2) for v in BASE_AMM]

            payload = {
                'flow': flow,
                'doVals': doVals,
                'bodVals': bodVals,
                'ammVals': ammVals,
                'timestamp': int(time.time())
            }
            self._set_headers(200)
            self.wfile.write(json.dumps(payload).encode('utf-8'))
        else:
            self._set_headers(404)
            self.wfile.write(json.dumps({'error': 'Not found'}).encode('utf-8'))


if __name__ == '__main__':
    print(f'Starting mock server at http://{HOST}:{PORT}/api/river')
    print('CORS enabled (Access-Control-Allow-Origin: *)')
    server = HTTPServer((HOST, PORT), Handler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print('\nShutting down')
        server.server_close()
