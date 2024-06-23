from fastapi import FastAPI
from models.base import Base
from pydantic_schemas.user_create import UserCreate
from routes import auth
from database import engin

app=FastAPI()
app.include_router(auth.router,prefix='/auth')
   
Base.metadata.create_all(engin)
