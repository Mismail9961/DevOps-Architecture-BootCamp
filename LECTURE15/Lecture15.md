# Python JSON + FastAPI: Server Monitoring API — Practical Guide

A condensed, hands-on rewrite of the tutorial — with the actual code and commands filled in so you can copy-paste and run it, instead of just reading about the concepts.

---

## 1. Project Setup

```bash
# Create project folder
mkdir server-api && cd server-api

# Create and activate a virtual environment (keeps deps isolated)
python3 -m venv venv
source venv/bin/activate        # Linux/Mac
# venv\Scripts\activate         # Windows

# Install dependencies
pip install fastapi "uvicorn[standard]"
```

**Why a venv matters:** without it, `uvicorn` often installs to a path your shell can't find, causing the classic `command not found: uvicorn` error mentioned in the video. A venv keeps the binary on a predictable, activated PATH.

---

## 2. Python Function Basics (Recap)

```python
def greet(name: str) -> str:
    return f"Hello, {name}!"

print(greet("Ismail"))
```

Type hints (`name: str`, `-> str`) aren't required but are considered best practice — FastAPI actually *relies* on them later to auto-validate request/response data.

---

## 3. Sample JSON Data

Create `data.json`:

```json
{
  "server_name": "web-01",
  "ip_address": "192.168.1.10",
  "status": true,
  "id": 1,
  "cpu_usage": 42.5,
  "memory_usage": 68.2,
  "users": ["admin", "ismail", "monitor_bot"]
}
```

---

## 4. Read/Write JSON Functions (Optimized)

```python
import json
from pathlib import Path

DATA_FILE = Path(__file__).parent / "data.json"

def read_json() -> dict:
    """Load and return the JSON file contents as a dict."""
    with open(DATA_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

def write_json(data: dict) -> None:
    """Persist a dict back to the JSON file, pretty-printed."""
    with open(DATA_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4)
```

**Key optimizations vs. the video's version:**
- `Path(__file__).parent` builds an absolute path to the JSON file, so the script works no matter which directory you run it from — this fixes the "file not found" issue that trips people up when running `uvicorn` from a different folder.
- `with open(...)` auto-closes the file even if an error occurs (no dangling file handles).
- `encoding="utf-8"` avoids silent encoding bugs on Windows.

---

## 5. FastAPI Application

Create `main.py`:

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from file_ops import read_json, write_json   # your read/write functions above

app = FastAPI(title="Server Monitoring API")

# Pydantic model = automatic request validation + auto-generated docs
class ServerUpdate(BaseModel):
    status: bool | None = None
    cpu_usage: float | None = None
    memory_usage: float | None = None

@app.get("/")
def home():
    return {"message": "API is running"}

@app.get("/data")
def get_data():
    return read_json()

@app.post("/data")
def update_data(update: ServerUpdate):
    data = read_json()
    update_dict = update.model_dump(exclude_unset=True)
    if not update_dict:
        raise HTTPException(status_code=400, detail="No fields provided to update")
    data.update(update_dict)
    write_json(data)
    return {"message": "Data updated", "data": data}
```

**Key optimizations vs. the video's version:**
- Uses a `Pydantic` model (`ServerUpdate`) instead of accepting a raw dict — this gives you free input validation, type coercion, and interactive API docs.
- `exclude_unset=True` means POST requests only need to send the fields they're changing, not the whole object.
- Returns a proper `400` error via `HTTPException` if the request body is empty, instead of failing silently.

---

## 6. Running the API

```bash
uvicorn main:app --reload --port 8000
```

| Flag | Purpose |
|---|---|
| `main:app` | `main.py` file → `app` object inside it |
| `--reload` | Hot-reloads on code changes (dev only — remove in production) |
| `--port 8000` | Avoids conflicts if another service is on the default port |
| `--host 0.0.0.0` | Add this if you need the API reachable from other machines on your network |

**Fixing the `uvicorn: command not found` PATH issue** mentioned in the video (if not using a venv):

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Test it's alive:**

```bash
curl http://127.0.0.1:8000/
curl http://127.0.0.1:8000/data
curl -X POST http://127.0.0.1:8000/data \
  -H "Content-Type: application/json" \
  -d '{"cpu_usage": 75.3, "status": true}'
```

**Bonus — free interactive docs:** FastAPI auto-generates a Swagger UI at:
```
http://127.0.0.1:8000/docs
```
No extra code needed — useful for testing endpoints without curl/Postman.

---

## 7. Extending It: Multi-Server Monitoring

The video's "real world" use case — one JSON file, one endpoint per server, or a single endpoint keyed by server ID:

```python
@app.get("/servers/{server_id}")
def get_server(server_id: int):
    data = read_json()
    servers = data.get("servers", [])
    for s in servers:
        if s["id"] == server_id:
            return s
    raise HTTPException(status_code=404, detail="Server not found")
```

For anything beyond a handful of servers, swap the flat JSON file for **SQLite** — concurrent writes to a single JSON file from multiple monitoring scripts will eventually corrupt data (no locking). SQLite (via Python's built-in `sqlite3`) gives you the same simplicity with safe concurrent access.

---

## 8. Running in the Background / Production Notes

- **Dev:** `uvicorn main:app --reload`
- **Production:** drop `--reload`, add a process manager so it survives reboots/crashes:
  ```bash
  pip install gunicorn
  gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
  ```
- Or run it as a `systemd` service so it auto-restarts on failure and starts on boot — worth doing for any server-monitoring API that needs to stay up continuously.

---

## Quick Reference: Command Cheat Sheet

```bash
# Setup
python3 -m venv venv && source venv/bin/activate
pip install fastapi "uvicorn[standard]"

# Run (dev)
uvicorn main:app --reload --port 8000

# Run (prod)
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000

# Test
curl http://127.0.0.1:8000/data
```