"""
Student API Routes
Student-specific operations: enrollment, grades, schedule viewing
"""
from fastapi import APIRouter, HTTPException, Header, Depends, status
from typing import Optional
import logging

# Configure logging
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/student", tags=["Student"])


def verify_student_role(authorization: Optional[str] = Header(None)):
    """
    Dependency to verify that the user has STUDENT role
    
    Args:
        authorization: Authorization header with Bearer token
        
    Returns:
        Decoded user info if STUDENT role
        
    Raises:
        HTTPException 401: If no token provided
        HTTPException 403: If not STUDENT role
    """
    if not authorization:
        logger.warning("Student endpoint accessed without authorization token")
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
        
        # Check if role is STUDENT
        if role != "STUDENT":
            logger.warning(f"Student endpoint accessed by non-student role: {role} (User: {user_id})")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Student access only. This endpoint is restricted to STUDENT role. Your role: {role}"
            )
        
        logger.info(f"Student endpoint accessed by STUDENT: {user_id}")
        
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
async def get_student_dashboard(user_info: dict = Depends(verify_student_role)):
    """
    Get student dashboard data and overview
    
    This endpoint is ONLY accessible by users with STUDENT role.
    Returns 403 Forbidden if accessed by ADMIN or TEACHER.
    
    Returns:
        Student dashboard data with today's exam, attendance, events, and alerts
    """
    logger.info(f"Fetching student dashboard for: {user_info['user_id']}")
    
    # Mock data - no database
    # This data structure is designed for the Flutter Student Home Screen
    return {
        "today_exam": {
            "subject": "Database Management Systems",
            "time": "10:00 AM - 12:00 PM",
            "room": "Room 304, Block A"
        },
        "attendance": {
            "percentage": 78.5,
            "status": "Good Standing"
        },
        "upcoming_events": [
            {
                "title": "Midterm Exam - Data Structures",
                "date": "December 22, 2025"
            },
            {
                "title": "Project Submission - Web Development",
                "date": "December 25, 2025"
            },
            {
                "title": "Guest Lecture - AI & Machine Learning",
                "date": "December 28, 2025"
            }
        ],
        "alerts_preview": [
            {
                "type": "urgent",
                "message": "Assignment due tomorrow: Operating Systems Lab Report"
            },
            {
                "type": "warning",
                "message": "Attendance below 80% in Computer Networks course"
            },
            {
                "type": "info",
                "message": "Library books due for return by December 20th"
            }
        ]
    }


@router.get("/courses")
async def get_enrolled_courses():
    """Get student's enrolled courses"""
    pass


@router.get("/grades")
async def get_grades():
    """Get student grades"""
    pass


@router.get("/schedule")
async def get_schedule():
    """Get student class schedule"""
    pass

