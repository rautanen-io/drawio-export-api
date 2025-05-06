"""FastAPI application for converting Draw.io files to SVG."""

import os
import subprocess
import tempfile
from io import BytesIO
from typing import Optional

from fastapi import Depends, FastAPI, File, HTTPException, UploadFile
from fastapi.responses import JSONResponse
from fastapi.security.http import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel
from starlette import status
from starlette.responses import StreamingResponse

app = FastAPI()

DRAWIO_EXPORT_API_TOKEN = os.environ.get("DRAWIO_EXPORT_API_TOKEN")
known_tokens = set([DRAWIO_EXPORT_API_TOKEN])
get_bearer_token = HTTPBearer(auto_error=False)


class UnauthorizedMessage(BaseModel):
    """Response model for unauthorized access attempts."""

    detail: str = "Bearer token missing or unknown"


async def get_token(
    auth: Optional[HTTPAuthorizationCredentials] = Depends(get_bearer_token),
) -> str:
    """Validate and return the bearer token from the authorization header."""
    if auth is None or (token := auth.credentials) not in known_tokens:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=UnauthorizedMessage().detail,
        )
    return token


@app.post(
    "/svg",
    response_model=dict,
    responses={status.HTTP_401_UNAUTHORIZED: dict(model=UnauthorizedMessage)},
)
async def svg(_: str = Depends(get_token), file: UploadFile = File(...)):
    """Convert a Draw.io file to SVG format and return it as a streaming response."""

    with tempfile.TemporaryDirectory() as tmp_dir:
        drawio_file_path = os.path.join(tmp_dir, file.filename)
        with open(drawio_file_path, "wb") as f:
            f.write(await file.read())

        cmd = [
            "/opt/drawio-desktop/entrypoint.sh",
            "-f",
            "svg",
            "-o",
            tmp_dir,
            drawio_file_path,
        ]
        try:
            subprocess.run(cmd, check=True, text=True)
        except subprocess.CalledProcessError:
            error_message = {
                "error": "Error: Something went wrong. Is your draw.io in valid format?"
            }
            return JSONResponse(content=error_message, status_code=400)

        svg_file_path = os.path.join(tmp_dir, "image-Page-1.svg")
        if not os.path.exists(svg_file_path):
            raise HTTPException(status_code=404, detail="File not found")

        with open(svg_file_path, "rb") as f:
            file_bytes = f.read()

        return StreamingResponse(BytesIO(file_bytes), media_type="image/svg+xml")
