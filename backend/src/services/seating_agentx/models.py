"""
Pydantic Models for SeatingAgentX
Request and Response schemas for exam seating allocation
"""

from typing import List, Literal, Optional
from pydantic import BaseModel, Field, validator


class HallConfig(BaseModel):
    """Configuration for a single examination hall"""
    hall_id: str = Field(..., description="Unique hall identifier")
    benches: int = Field(..., gt=0, description="Number of benches in the hall")


class SeatingRequest(BaseModel):
    """Request model for generating exam seating allocation"""
    exam_id: str = Field(..., description="Unique exam identifier")
    exam_type: Literal["SEM", "CIA"] = Field(..., description="Exam type: Semester or CIA")
    subject: str = Field(..., description="Subject/Course code for the exam")
    time_slot: int = Field(..., description="Exam time slot (1=09:00-11:00, 2=10:00-12:00, 3=14:00-16:00)")
    departments: List[str] = Field(..., description="List of departments (e.g., ['CSE', 'ECE'])")
    years: List[int] = Field(..., description="List of academic years (e.g., [1, 2])")
    halls: List[HallConfig] = Field(..., min_items=1, description="Hall configurations")
    bench_capacity: int = Field(default=2, description="Students per bench (must be 2)")

    @validator('bench_capacity')
    def validate_bench_capacity(cls, v):
        """Bench capacity must be exactly 2"""
        if v != 2:
            raise ValueError("bench_capacity must be 2")
        return v

    @validator('halls')
    def validate_halls(cls, v):
        """Ensure halls list is not empty"""
        if not v:
            raise ValueError("halls list cannot be empty")
        return v
    
    @validator('subject')
    def validate_subject(cls, v):
        """Ensure subject is not empty"""
        if not v or not v.strip():
            raise ValueError("subject cannot be empty")
        return v.strip()

    @validator('time_slot')
    def validate_time_slot(cls, v):
        """Ensure time_slot is strictly 1, 2, or 3"""
        if v not in [1, 2, 3]:
            raise ValueError("time_slot must be 1 (09:00-11:00), 2 (10:00-12:00), or 3 (14:00-16:00)")
        return v

    @validator('departments')
    def validate_departments(cls, v):
        """Ensure departments list is not empty"""
        if not v:
            raise ValueError("departments list cannot be empty")
        return v

    @validator('years')
    def validate_years(cls, v):
        """Ensure years list is not empty"""
        if not v:
            raise ValueError("years list cannot be empty")
        for year in v:
            if not (1 <= year <= 4):
                raise ValueError(f"Invalid year: {year}. Must be 1-4")
        return v


class StudentInfo(BaseModel):
    """Student information for seat assignment"""
    roll_no: str = Field(..., description="Student roll number")
    department: str = Field(..., description="Student department")
    year: int = Field(..., description="Academic year")
    name: Optional[str] = Field(None, description="Student name")


class SeatAssignment(BaseModel):
    """Single bench seat assignment"""
    exam_id: str
    hall_id: str
    bench_no: int
    left_student: Optional[StudentInfo] = None
    right_student: Optional[StudentInfo] = None


class SeatingResponse(BaseModel):
    """Response model for seating allocation"""
    exam_id: str
    exam_type: str
    time_slot: int
    total_students: int
    total_benches: int
    allocated_students: int
    allocations: List[SeatAssignment]
    message: str


class HallSeatingResponse(BaseModel):
    """Response for hall-specific seating query"""
    exam_id: str
    hall_id: str
    benches: List[SeatAssignment]


class StudentSeatingResponse(BaseModel):
    """Response for student-specific seating query"""
    exam_id: str
    student: StudentInfo
    hall_id: str
    bench_no: int
    seat_position: Literal["left", "right"]

