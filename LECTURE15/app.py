from fastapi import FastAPI
import json



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