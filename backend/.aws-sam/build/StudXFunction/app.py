from fastapi import FastAPI
from mangum import Mangum
import logging

# Import routers
from api.auth import router as auth_router
from api.faculty import router as faculty_router
from api.admin import router as admin_router
from api.student import router as student_router
from api.seating import router as seating_router

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

# Initialize FastAPI with API Gateway stage support
app = FastAPI(
    title="StudX ERP Backend",
    description="University ERP System - Authentication & Management API",
    version="1.0.0",
    root_path="/Prod"  # API Gateway stage path
)

# Include routers
# Note: Routers already have their prefixes defined in their respective files
app.include_router(auth_router)
app.include_router(faculty_router)
app.include_router(admin_router)
app.include_router(student_router)
app.include_router(seating_router)

@app.get("/health")
def health():
    return {"status": "StudX backend running"}

@app.get("/")
def root():
    return {"message": "Welcome to StudX API"}

handler = Mangum(app)
