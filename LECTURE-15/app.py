from fastapi import FastAPI
import json

app = FastAPI()

@app.get("/")
def home():
    return {"message": "Hello World"}

@app.get("/data")
def get_data():
    return read_data()

def read_data():
    with open('server.json', 'r') as file:
       json_data = json.load(file)
    return json_data


def write_data(data):
    with open('server.json', 'w')as file:
        json.dump(data, file, indent=4)

data = read_data()
data["server"]["status"] = "stopped"
write_data(data)