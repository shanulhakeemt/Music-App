from fastapi import FastAPI
from models.base import Base
from pydantic_schemas.user_create import UserCreate
from routes import auth,song
from database import engin
import uvicorn


app=FastAPI()
app.include_router(auth.router,prefix='/auth')
app.include_router(song.router,prefix='/song')

uvicorn.run(app, host="192.168.143.62", port=8000)
   
Base.metadata.create_all(engin)
