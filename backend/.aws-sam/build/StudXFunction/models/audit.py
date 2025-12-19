"""
Audit Log Models
Defines audit trail and activity logging models
"""
from pydantic import BaseModel
from typing import Optional, Dict, Any
from datetime import datetime
from enum import Enum


class AuditAction(str, Enum):
    """Audit action types"""
    CREATE = "create"
    READ = "read"
    UPDATE = "update"
    DELETE = "delete"
    LOGIN = "login"
    LOGOUT = "logout"
    EXPORT = "export"
    IMPORT = "import"


class AuditResource(str, Enum):
    """Resource types for audit"""
    USER = "user"
    EXAM = "exam"
    ATTENDANCE = "attendance"
    GRADE = "grade"
    SEATING = "seating"
    NOTIFICATION = "notification"
    SYSTEM = "system"


class AuditLogBase(BaseModel):
    """Base audit log model"""
    user_id: str
    action: AuditAction
    resource: AuditResource
    resource_id: Optional[str] = None
    description: str
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class AuditLogCreate(AuditLogBase):
    """Audit log creation model"""
    pass


class AuditLog(AuditLogBase):
    """Audit log response model"""
    id: str
    timestamp: datetime

    class Config:
        from_attributes = True


class AuditLogFilter(BaseModel):
    """Audit log filter model"""
    user_id: Optional[str] = None
    action: Optional[AuditAction] = None
    resource: Optional[AuditResource] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    limit: int = 100
    offset: int = 0

