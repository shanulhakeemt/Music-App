from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token=Header()):
    try:
      if not x_auth_token:
            raise HTTPException(401,"No auth token, Access denied!")
      verified_token=jwt.decode(x_auth_token,"password_key",["HS256"])
      if not verified_token:
            raise HTTPException(401,"Verification failed, autherization denied!")
            
      uid =verified_token.get('id')
      return {"uid":uid,"token":x_auth_token}  
    except jwt.PyJWTError:
       raise HTTPException(401,"Not a valid token, autherization failed!")