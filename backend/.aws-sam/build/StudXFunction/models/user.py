"""
User Models
Defines User, Admin, Faculty, and Student data models
"""
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime
from enum import Enum


class UserRole(str, Enum):
    """User role enumeration"""
    ADMIN = "admin"
    FACULTY = "faculty"
    STUDENT = "student"


class UserBase(BaseModel):
    """Base user model"""
    email: EmailStr
    username: str
    full_name: str
    role: UserRole
    is_active: bool = True


class UserCreate(UserBase):
    """User creation model"""
    password: str


class UserUpdate(BaseModel):
    """User update model"""
    email: Optional[EmailStr] = None
    username: Optional[str] = None
    full_name: Optional[str] = None
    is_active: Optional[bool] = None


class UserInDB(UserBase):
    """User database model"""
    id: str
    hashed_password: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class User(UserBase):
    """User response model"""
    id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class StudentProfile(BaseModel):
    """Student-specific profile"""
    user_id: str
    student_id: str
    enrollment_year: int
    department: str
    semester: int
    cgpa: Optional[float] = None


class FacultyProfile(BaseModel):
    """Faculty-specific profile"""
    user_id: str
    faculty_id: str
    department: str
    designation: str
    specialization: Optional[str] = None

