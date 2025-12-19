"""
Exam Models
Defines exam, exam schedule, and result data models
"""
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from enum import Enum


class ExamType(str, Enum):
    """Exam type enumeration"""
    MIDTERM = "midterm"
    ENDTERM = "endterm"
    QUIZ = "quiz"
    PRACTICAL = "practical"


class ExamStatus(str, Enum):
    """Exam status enumeration"""
    SCHEDULED = "scheduled"
    ONGOING = "ongoing"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class ExamBase(BaseModel):
    """Base exam model"""
    course_id: str
    exam_type: ExamType
    title: str
    description: Optional[str] = None
    exam_date: datetime
    duration_minutes: int
    total_marks: int
    venue: Optional[str] = None


class ExamCreate(ExamBase):
    """Exam creation model"""
    pass


class ExamUpdate(BaseModel):
    """Exam update model"""
    title: Optional[str] = None
    description: Optional[str] = None
    exam_date: Optional[datetime] = None
    duration_minutes: Optional[int] = None
    total_marks: Optional[int] = None
    venue: Optional[str] = None
    status: Optional[ExamStatus] = None


class Exam(ExamBase):
    """Exam response model"""
    id: str
    status: ExamStatus
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ExamResult(BaseModel):
    """Exam result model"""
    id: str
    exam_id: str
    student_id: str
    marks_obtained: float
    grade: Optional[str] = None
    remarks: Optional[str] = None
    evaluated_by: str
    evaluated_at: datetime

    class Config:
        from_attributes = True

