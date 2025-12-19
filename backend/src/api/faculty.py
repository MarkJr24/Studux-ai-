"""
Faculty API Routes
Faculty-specific operations: courses, student management, grading
"""
from fastapi import APIRouter, HTTPException, Header, Depends, status
from typing import Optional
import logging

# Configure logging
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/faculty", tags=["Faculty"])


def verify_teacher_role(authorization: Optional[str] = Header(None)):
    """
    Dependency to verify that the user has TEACHER role
    
    Args:
        authorization: Authorization header with Bearer token
        
    Returns:
        Decoded user info if TEACHER role
        
    Raises:
        HTTPException 401: If no token provided
        HTTPException 403: If not TEACHER role
    """
    if not authorization:
        logger.warning("Faculty endpoint accessed without authorization token")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authorization token required"
        )
    
    # Extract token from "Bearer <token>"
    try:
        token_parts = authorization.split(" ")
        if len(token_parts) != 2 or token_parts[0].lower() != "bearer":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authorization format. Use: Bearer <token>"
            )
        
        token = token_parts[1]
        
        # Parse mock token format: "mock-jwt-token-{user_id}-{role}"
        if not token.startswith("mock-jwt-token-"):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token format"
            )
        
        # Extract role from token
        token_parts = token.split("-")
        if len(token_parts) < 4:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token structure"
            )
        
        role = token_parts[-1]  # Last part is the role
        user_id = token_parts[-2]  # Second to last is user_id
        
        # Check if role is TEACHER
        if role != "TEACHER":
            logger.warning(f"Faculty endpoint accessed by non-teacher role: {role} (User: {user_id})")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Access denied. This endpoint is only for TEACHER role. Your role: {role}"
            )
        
        logger.info(f"Faculty endpoint accessed by TEACHER: {user_id}")
        
        return {"user_id": user_id, "role": role}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error parsing token: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )


@router.get("/dashboard")
async def get_faculty_dashboard(user_info: dict = Depends(verify_teacher_role)):
    """
    Get teacher dashboard statistics and overview
    
    This endpoint is ONLY accessible by users with TEACHER role.
    Returns 403 Forbidden if accessed by ADMIN or STUDENT.
    
    Returns:
        Teacher dashboard data with stats, upcoming schedule, and alerts
    """
    logger.info(f"Fetching teacher dashboard for: {user_info['user_id']}")
    
    # Mock data - no database
    # This data structure is designed for the Flutter Teacher Home Screen
    return {
        "stats": {
            "classes_today": 3,
            "pending_attendance": 2,
            "today_invigilation": 1
        },
        "next_30_min": {
            "title": "CS301 - Database Management Systems",
            "time": "10:00 AM - 11:30 AM",
            "action": "Room 304, Section A"
        },
        "recent_alerts": [
            {
                "type": "urgent",
                "message": "Attendance pending for CS101 Section A (Yesterday)"
            },
            {
                "type": "reminder",
                "message": "Submit midterm grades by December 22nd"
            },
            {
                "type": "info",
                "message": "Faculty meeting scheduled for tomorrow at 2 PM"
            }
        ]
    }


@router.get("/classes")
async def get_faculty_classes(user_info: dict = Depends(verify_teacher_role)):
    """
    Get list of classes assigned to faculty member
    
    This endpoint is ONLY accessible by users with TEACHER role.
    Returns 403 Forbidden if accessed by ADMIN or STUDENT.
    
    Returns:
        Mock list of classes (for testing role-based access)
    """
    logger.info(f"Fetching classes for faculty: {user_info['user_id']}")
    
    # Mock data - no database
    return {
        "faculty_id": user_info["user_id"],
        "role": user_info["role"],
        "classes": [
            {
                "class_id": "CS101",
                "class_name": "Introduction to Computer Science",
                "section": "A",
                "students_enrolled": 45,
                "schedule": "Mon/Wed 10:00-11:30"
            },
            {
                "class_id": "CS201",
                "class_name": "Data Structures",
                "section": "B",
                "students_enrolled": 38,
                "schedule": "Tue/Thu 14:00-15:30"
            },
            {
                "class_id": "CS301",
                "class_name": "Database Management Systems",
                "section": "A",
                "students_enrolled": 42,
                "schedule": "Wed/Fri 09:00-10:30"
            }
        ],
        "total_classes": 3
    }


@router.get("/courses")
async def get_faculty_courses():
    """Get courses assigned to faculty"""
    pass


@router.get("/students/{course_id}")
async def get_course_students():
    """Get students enrolled in a course"""
    pass


@router.post("/grades")
async def submit_grades():
    """Submit or update student grades"""
    pass


@router.get("/dashboard")
async def faculty_dashboard():
    """Faculty dashboard overview"""
    pass

