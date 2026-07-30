# Server Monitoring API (FastAPI + JSON)

A lightweight FastAPI application for monitoring multiple remote servers, using a simple JSON file (`server.json`) as the datastore instead of a database. Ideal for early-stage DevOps tooling where you want to track hostname, IP, and status for a handful of servers without the overhead of setting up and maintaining a database.

## Why JSON instead of a database?

- Zero setup — no DB server, drivers, or connection strings to manage.
- Easy to read/edit by hand during development.
- Good enough for early-stage projects (e.g. tracking 40+ EC2 servers).
- Trade-off: no versioning, no real querying power, no concurrent-write safety.

As the project grows, the plan is to migrate to a proper database (MongoDB, AWS RDS, ElastiCache) for better scalability, querying, and multi-writer safety.

## Requirements

- Python 3.8+
- `fastapi`
- `uvicorn`

## Setup

```bash
# 1. Go to your project directory
cd ~/server-monitor

# 2. (Recommended) create a virtual environment
python3 -m venv venv
source venv/bin/activate

# 3. Install dependencies
pip install fastapi uvicorn

# 4. Create the initial JSON datastore
echo "{}" > server.json
```

## Running the server

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

- `--reload` — auto-restarts the server on code changes (development only).
- `--host 0.0.0.0` — makes the API reachable from other machines (e.g. remote EC2 servers posting their status).
- `--port 8000` — change if 8000 is already in use.

Once running, interactive API docs are available at:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## Project structure

```
server-monitor/
├── main.py        # FastAPI app (routes + JSON I/O helpers)
├── server.json     # Datastore (auto-created/updated by the app)
└── README.md
```

## Core concepts

### JSON helper functions
- `read_json_file()` — opens `server.json`, loads it into a Python dict, returns it.
- `write_json_file(data)` — writes a Python dict back to `server.json` with `indent=4` for readability.

All routes read from and write to these helpers rather than touching the file directly — this keeps the file I/O logic in one place.

### Data model
Each server is stored as a key in the JSON object, where the key is the server name and the value is a dict of its metadata (e.g. IP, hostname, status):

```json
{
  "web-01": {
    "ip": "192.168.1.10",
    "status": "running"
  },
  "db-01": {
    "ip": "192.168.1.20",
    "status": "stopped"
  }
}
```

## API Endpoints

| Method | Route                        | Description                                      |
|--------|-------------------------------|---------------------------------------------------|
| GET    | `/`                            | Health check — confirms the server is running     |
| GET    | `/read`                        | Returns all server data from `server.json`         |
| GET    | `/data/serverlist`             | Returns just the list of server names (keys)       |
| GET    | `/data/{servername}`           | Returns data for a specific server                 |
| POST   | `/server`                      | Adds a new server entry                            |
| PUT    | `/server/{server_name}`        | Updates the status of an existing server            |

### Important notes
- `server_name` / `servername` is always treated as a **string**, even if it looks numeric — this avoids type-mismatch bugs when matching against JSON dict keys.
- `GET /data/{servername}` returns `{"error": "Server not found"}` if the server doesn't exist (rather than raising an HTTP 404 — keep this in mind if you plan to add proper error status codes later).
- `POST /server` checks for duplicates before writing — if `server_name` already exists, it returns an error instead of overwriting.
- `PUT /server/{server_name}` only updates the `status` field of an existing server; it does not create the server if missing.

## Testing with curl

**Health check**
```bash
curl http://localhost:8000/
```

**Get all server data**
```bash
curl http://localhost:8000/read
```

**Get list of server names**
```bash
curl http://localhost:8000/data/serverlist
```

**Get a specific server**
```bash
curl http://localhost:8000/data/web-01
```

**Add a new server**
```bash
curl -X POST "http://localhost:8000/server?server_name=web-01" \
  -H "Content-Type: application/json" \
  -d '{
        "ip": "192.168.1.10",
        "status": "running"
      }'
```

**Update a server's status**
```bash
curl -X PUT "http://localhost:8000/server/web-01?status=stopped"
```

## Common issues

| Issue                                       | Cause / Fix                                                                 |
|----------------------------------------------|-------------------------------------------------------------------------------|
| `FileNotFoundError: server.json`              | Run `echo "{}" > server.json` before starting the server                     |
| `422 Unprocessable Entity` on POST/PUT        | Check you're passing `server_name`/`status` as query params, and the body as valid JSON |
| Server name mismatch (e.g. `1` vs `"1"`)      | Always send server names as strings                                          |
| Changes not reflecting                        | Make sure you're running with `--reload` during development                  |

## Suggested next steps (from the lecture)

- Use proper HTTP status codes (404 for not found, 409 for conflict, etc.) instead of returning `{"error": ...}` with a 200 status.
- Move `server_name` in `POST /server` and `status` in `PUT /server/{server_name}` into the request body / Pydantic models for cleaner validation instead of query params.
- Add a bash script on each monitored server that periodically POSTs/PUTs its status to this API for centralized, real-time tracking.
- Migrate from JSON file storage to a real database (MongoDB, AWS RDS, etc.) once you need versioning, concurrent writes, or complex queries.