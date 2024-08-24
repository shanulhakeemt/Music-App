from fastapi import FastAPI
from models.base import Base
from pydantic_schemas.user_create import UserCreate
from routes import auth
from database import engin
import uvicorn

app=FastAPI()
app.include_router(auth.router,prefix='/auth')

uvicorn.run(app, host="192.168.83.62", port=8000)
   
Base.metadata.create_all(engin)
