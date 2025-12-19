"""
Admin API Routes
Administrative functions for user management, system settings, and oversight
"""
from fastapi import APIRouter, HTTPException, Header, Depends, status
from typing import Optional
import logging

# Configure logging
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/admin", tags=["Admin"])


def verify_admin_role(authorization: Optional[str] = Header(None)):
    """
    Dependency to verify that the user has ADMIN role
    
    Args:
        authorization: Authorization header with Bearer token
        
    Returns:
        Decoded user info if ADMIN role
        
    Raises:
        HTTPException 401: If no token provided
        HTTPException 403: If not ADMIN role
    """
    if not authorization:
        logger.warning("Admin endpoint accessed without authorization token")
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
        
        # Check if role is ADMIN
        if role != "ADMIN":
            logger.warning(f"Admin endpoint accessed by non-admin role: {role} (User: {user_id})")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Access denied. This endpoint is only for ADMIN role. Your role: {role}"
            )
        
        logger.info(f"Admin endpoint accessed by ADMIN: {user_id}")
        
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
async def admin_dashboard(user_info: dict = Depends(verify_admin_role)):
    """
    Get admin dashboard statistics and overview
    
    This endpoint is ONLY accessible by users with ADMIN role.
    Returns 403 Forbidden if accessed by TEACHER or STUDENT.
    
    Returns:
        Admin dashboard data with stats, recent activity, and alerts
    """
    logger.info(f"Fetching admin dashboard for: {user_info['user_id']}")
    
    # Mock data - no database
    # This data structure is designed for the Flutter Admin Home Screen
    return {
        "stats": {
            "upcoming_exams": 8,
            "pending_seating": 5,
            "pending_audits": 12,
            "pending_events": 3
        },
        "recent_activity": [
            "Teacher account created for Dr. Sarah Johnson",
            "Exam seating arrangement finalized for CS301",
            "Student enrollment approved for 45 students",
            "Faculty meeting scheduled for December 25th",
            "Audit log exported for November activities"
        ],
        "alerts_preview": [
            {
                "type": "urgent",
                "message": "5 exam seating arrangements require immediate attention"
            },
            {
                "type": "warning",
                "message": "12 audit logs pending review before end of semester"
            },
            {
                "type": "info",
                "message": "System maintenance scheduled for this weekend"
            }
        ]
    }


@router.get("/users")
async def get_all_users():
    """Get all users in the system"""
    pass


@router.post("/users")
async def create_user():
    """Create new user (Admin, Faculty, Student)"""
    pass


@router.put("/users/{user_id}")
async def update_user():
    """Update user details"""
    pass


@router.delete("/users/{user_id}")
async def delete_user():
    """Delete user from system"""
    pass

