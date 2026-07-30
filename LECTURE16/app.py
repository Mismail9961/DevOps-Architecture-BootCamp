from fastapi import FastAPI
import json
import uvicorn

app = FastAPI()

def read_json_file():
    with open('server.json', 'r') as file:
        data = json.load(file)
    return data 

def write_json_file(data):
    with open('server.json', 'w') as file:
        json.dump(data, file, indent = 4)

@app.get("/")
def root_path():
    return {
        "server": "Server is running",
        "status": "OK"
        }

@app.get("/read")
def read_data():
    return read_json_file()

@app.get('/data/serverlist')
def server_list_read():
    data = read_json_file()
    return list(data.keys())

@app.get('/data/{servername}')
def server_data_read(servername:str):
    data = read_json_file()
    return data.get(servername, {"error": "Server not found"})

@app.post('/server')
def add_server(server_name:str, server: dict):
    data = read_json_file()
    if server_name in data:
        return {"error": "Server already exists"}
    data[server_name] = server
    write_json_file(data)
    return {"message": "Server added successfully"}

@app.put('/server/{server_name}')
def update_server(server_name: str, status: str):
    data = read_json_file()
    if server_name not in data:
        return {"error": "Server not found"}
    data[server_name]['status'] = status
    write_json_file(data)
    return {"message": "Server status updated successfully"}