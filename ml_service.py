# ml_service.py
from fastapi import FastAPI, File, UploadFile, HTTPException
from PIL import Image
import imagehash
import io, requests, json
from typing import List

app = FastAPI()

# Config: backend base URL (change to your backend)
BACKEND_BASE = "http://127.0.0.1:8000"
BACKEND_API_KEY = ""  # optional secret to authorize template fetch

def image_to_hash(img_bytes):
    img = Image.open(io.BytesIO(img_bytes)).convert('L').resize((256,256))
    ph = imagehash.phash(img)  # perceptual hash
    # represent as int vector (64-bit)
    return int(str(ph), 16)

def hamming_distance(a:int, b:int) -> int:
    return bin(a ^ b).count('1')

@app.post("/recognize")
async def recognize(file: UploadFile = File(...)):
    # read image
    img_bytes = await file.read()
    probe_hash = image_to_hash(img_bytes)

    # fetch iris templates from backend (simple: backend returns list of {student_id, hash})
    resp = requests.get(f"{BACKEND_BASE}/api/iris-templates", headers={"Accept":"application/json"})
    if resp.status_code != 200:
        raise HTTPException(status_code=500, detail="Could not fetch templates")

    templates = resp.json()  # expected [{ student_id:.., embedding: "hexstring" }, ...]
    best = None
    best_score = 9999
    for t in templates:
        # stored embedding should be integer (from imagehash). If JSON string, parse.
        stored = int(t['embedding'])
        dist = hamming_distance(probe_hash, stored)
        if dist < best_score:
            best_score = dist
            best = t

    # convert hamming distance to confidence (0->1)
    # Assume 64-bit hash; normalize: confidence = 1 - dist/64
    if best is None:
        return {"status":"no-match"}
    confidence = max(0.0, 1.0 - (best_score / 64.0))
    # thresholding
    if confidence < 0.6:
        return {"status":"no-match", "confidence":confidence}
    return {"status":"ok", "student_id": best['student_id'], "confidence": confidence}
