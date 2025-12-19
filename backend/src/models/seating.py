"""
Seating Arrangement Models
Defines seating arrangement data models for exams
"""
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class SeatBase(BaseModel):
    """Base seat model"""
    room_number: str
    seat_number: str
    is_available: bool = True


class SeatingArrangementBase(BaseModel):
    """Base seating arrangement model"""
    exam_id: str
    room_number: str
    capacity: int


class SeatingArrangementCreate(SeatingArrangementBase):
    """Seating arrangement creation model"""
    pass


class SeatingArrangement(SeatingArrangementBase):
    """Seating arrangement response model"""
    id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class SeatAssignmentBase(BaseModel):
    """Base seat assignment model"""
    seating_arrangement_id: str
    student_id: str
    seat_number: str
    roll_number: str


class SeatAssignmentCreate(SeatAssignmentBase):
    """Seat assignment creation model"""
    pass


class SeatAssignment(SeatAssignmentBase):
    """Seat assignment response model"""
    id: str
    exam_id: str
    room_number: str
    created_at: datetime

    class Config:
        from_attributes = True


class SeatingLayout(BaseModel):
    """Complete seating layout for an exam"""
    exam_id: str
    exam_title: str
    total_students: int
    arrangements: List[SeatingArrangement]
    assignments: List[SeatAssignment]

    class Config:
        from_attributes = True

