"""
Role-Based Access Control (RBAC)
Role definitions and permission checking utilities
"""
from enum import Enum
from typing import List
from fastapi import HTTPException, Depends
from core.security import get_current_active_user


class UserRole(str, Enum):
    """User role enumeration"""
    ADMIN = "admin"
    FACULTY = "faculty"
    STUDENT = "student"


class Permission(str, Enum):
    """System permissions"""
    # User Management
    USER_CREATE = "user:create"
    USER_READ = "user:read"
    USER_UPDATE = "user:update"
    USER_DELETE = "user:delete"
    
    # Course Management
    COURSE_CREATE = "course:create"
    COURSE_READ = "course:read"
    COURSE_UPDATE = "course:update"
    COURSE_DELETE = "course:delete"
    
    # Exam Management
    EXAM_CREATE = "exam:create"
    EXAM_READ = "exam:read"
    EXAM_UPDATE = "exam:update"
    EXAM_DELETE = "exam:delete"
    
    # Attendance Management
    ATTENDANCE_MARK = "attendance:mark"
    ATTENDANCE_READ = "attendance:read"
    ATTENDANCE_UPDATE = "attendance:update"
    
    # Grade Management
    GRADE_CREATE = "grade:create"
    GRADE_READ = "grade:read"
    GRADE_UPDATE = "grade:update"
    
    # Seating Management
    SEATING_GENERATE = "seating:generate"
    SEATING_READ = "seating:read"
    SEATING_UPDATE = "seating:update"
    
    # Audit Logs
    AUDIT_READ = "audit:read"
    AUDIT_EXPORT = "audit:export"
    
    # Notifications
    NOTIFICATION_SEND = "notification:send"
    NOTIFICATION_BROADCAST = "notification:broadcast"


# Role-based permissions mapping
ROLE_PERMISSIONS = {
    UserRole.ADMIN: [
        # Full system access
        Permission.USER_CREATE,
        Permission.USER_READ,
        Permission.USER_UPDATE,
        Permission.USER_DELETE,
        Permission.COURSE_CREATE,
        Permission.COURSE_READ,
        Permission.COURSE_UPDATE,
        Permission.COURSE_DELETE,
        Permission.EXAM_CREATE,
        Permission.EXAM_READ,
        Permission.EXAM_UPDATE,
        Permission.EXAM_DELETE,
        Permission.ATTENDANCE_MARK,
        Permission.ATTENDANCE_READ,
        Permission.ATTENDANCE_UPDATE,
        Permission.GRADE_CREATE,
        Permission.GRADE_READ,
        Permission.GRADE_UPDATE,
        Permission.SEATING_GENERATE,
        Permission.SEATING_READ,
        Permission.SEATING_UPDATE,
        Permission.AUDIT_READ,
        Permission.AUDIT_EXPORT,
        Permission.NOTIFICATION_SEND,
        Permission.NOTIFICATION_BROADCAST,
    ],
    UserRole.FACULTY: [
        # Faculty-specific permissions
        Permission.USER_READ,
        Permission.COURSE_READ,
        Permission.EXAM_CREATE,
        Permission.EXAM_READ,
        Permission.EXAM_UPDATE,
        Permission.ATTENDANCE_MARK,
        Permission.ATTENDANCE_READ,
        Permission.GRADE_CREATE,
        Permission.GRADE_READ,
        Permission.GRADE_UPDATE,
        Permission.SEATING_READ,
        Permission.NOTIFICATION_SEND,
    ],
    UserRole.STUDENT: [
        # Student-specific permissions (read-only mostly)
        Permission.COURSE_READ,
        Permission.EXAM_READ,
        Permission.ATTENDANCE_READ,
        Permission.GRADE_READ,
        Permission.SEATING_READ,
    ],
}


class RoleChecker:
    """Role-based access control checker"""

    def __init__(self, allowed_roles: List[UserRole]):
        """
        Initialize role checker with allowed roles
        
        Args:
            allowed_roles: List of roles allowed to access resource
        """
        self.allowed_roles = allowed_roles

    def __call__(self, current_user: dict = Depends(get_current_active_user)):
        """
        Check if current user has required role
        
        Args:
            current_user: Current authenticated user
            
        Raises:
            HTTPException: If user doesn't have required role
        """
        user_role = current_user.get("role")
        
        if user_role not in self.allowed_roles:
            raise HTTPException(
                status_code=403,
                detail=f"Access denied. Required roles: {[role.value for role in self.allowed_roles]}"
            )
        
        return current_user


class PermissionChecker:
    """Permission-based access control checker"""

    def __init__(self, required_permission: Permission):
        """
        Initialize permission checker
        
        Args:
            required_permission: Permission required to access resource
        """
        self.required_permission = required_permission

    def __call__(self, current_user: dict = Depends(get_current_active_user)):
        """
        Check if current user has required permission
        
        Args:
            current_user: Current authenticated user
            
        Raises:
            HTTPException: If user doesn't have required permission
        """
        user_role = current_user.get("role")
        
        if user_role not in ROLE_PERMISSIONS:
            raise HTTPException(
                status_code=403,
                detail="Invalid user role"
            )
        
        user_permissions = ROLE_PERMISSIONS[user_role]
        
        if self.required_permission not in user_permissions:
            raise HTTPException(
                status_code=403,
                detail=f"Insufficient permissions. Required: {self.required_permission.value}"
            )
        
        return current_user


def has_permission(user_role: UserRole, permission: Permission) -> bool:
    """
    Check if a role has a specific permission
    
    Args:
        user_role: User's role
        permission: Permission to check
        
    Returns:
        True if role has permission, False otherwise
    """
    if user_role not in ROLE_PERMISSIONS:
        return False
    
    return permission in ROLE_PERMISSIONS[user_role]


def get_role_permissions(user_role: UserRole) -> List[Permission]:
    """
    Get all permissions for a role
    
    Args:
        user_role: User's role
        
    Returns:
        List of permissions for the role
    """
    return ROLE_PERMISSIONS.get(user_role, [])

