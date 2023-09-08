from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    print("hola")
    return {"Hello":"World"}

# @app.get()