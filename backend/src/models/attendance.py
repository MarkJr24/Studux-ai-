"""
Attendance Models
Defines attendance tracking data models
"""
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, date
from enum import Enum


class AttendanceStatus(str, Enum):
    """Attendance status enumeration"""
    PRESENT = "present"
    ABSENT = "absent"
    LATE = "late"
    EXCUSED = "excused"


class AttendanceBase(BaseModel):
    """Base attendance model"""
    course_id: str
    student_id: str
    date: date
    status: AttendanceStatus
    remarks: Optional[str] = None


class AttendanceCreate(AttendanceBase):
    """Attendance creation model"""
    pass


class AttendanceUpdate(BaseModel):
    """Attendance update model"""
    status: Optional[AttendanceStatus] = None
    remarks: Optional[str] = None


class Attendance(AttendanceBase):
    """Attendance response model"""
    id: str
    marked_by: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class AttendanceReport(BaseModel):
    """Attendance report model"""
    student_id: str
    course_id: str
    total_classes: int
    present_count: int
    absent_count: int
    late_count: int
    excused_count: int
    attendance_percentage: float

    class Config:
        from_attributes = True

