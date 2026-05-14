Mock server for `pls.html` live data (local testing)

This repository includes a tiny local mock server at `hg/mock_server.py` that serves a CORS-enabled JSON endpoint for the River Timeline demo.

How it works
- Endpoint: http://127.0.0.1:8000/api/river
- Returns: JSON with `flow`, `doVals`, `bodVals`, `ammVals` arrays (each length 12) and a `timestamp`.
- The server adds small random noise each request so the chart updates visually.

Run it (PowerShell)
1. From the workspace root run:

```powershell
python .\hg\mock_server.py
```

2. Open `hg/pls.html` in your browser (or serve `hg` over a local HTTP server and browse there).

Notes
- The mock server sets `Access-Control-Allow-Origin: *` so `pls.html` can fetch from it when opened as a file or when served from a different origin.
- To stop the server press Ctrl+C.
- To change returned values edit the BASE_* arrays in `hg/mock_server.py`.

If you'd like, I can also add a small PowerShell script to run both a static server and the mock API together.
