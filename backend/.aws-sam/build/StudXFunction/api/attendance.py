"""
Attendance API Routes
Attendance marking, tracking, and reporting for all roles
"""
from fastapi import APIRouter

router = APIRouter(prefix="/attendance", tags=["Attendance"])


@router.post("/mark")
async def mark_attendance():
    """Mark attendance for students"""
    pass


@router.get("/report/{course_id}")
async def get_attendance_report():
    """Get attendance report for a course"""
    pass


@router.get("/student/{student_id}")
async def get_student_attendance():
    """Get attendance record for a student"""
    pass

