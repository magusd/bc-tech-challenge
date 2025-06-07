from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
import redis
import os
app = FastAPI()

host:str = os.environ.get("REDIS_HOST","")
r = redis.Redis(
    host=host,
    port=int(os.environ.get("REDIS_PORT","6379")), 
    username=os.environ.get("REDIS_USERNAME","default"),
    password=os.environ.get("REDIS_PASSWORD"),
    decode_responses=True
)
r.ping()

counter_key = "__bluecore_dev_counter__"

@app.get("/")
def read_root():
    return HTMLResponse("Hi! Welcome to the BlueCore something counter. Check the <a href='/docs'>/docs</a>.")

@app.get("/read")
def read_counter():
    count = r.get(counter_key) or 0
    return {"count": int(count)}

@app.post("/write")
def increment_counter():
    return {"count": r.incr(counter_key)}

@app.get("/healthz", response_class=HTMLResponse)
def healthz():
    return HTMLResponse("<h1>OK</h1>")
    try:
        r.ping()
    except redis.ConnectionError:
        raise HTTPException(status_code=500, detail="Can't connect to Redis")
    return "healthy"
