"""
Seating API Routes - SeatingAgentX
Exam seating allocation endpoints with role-based access control
"""

from fastapi import APIRouter, HTTPException, Header, Depends, status
from fastapi.responses import Response
from typing import Optional
import logging
import json

from services.seating_agentx.allocator import SeatingAllocator
from services.seating_agentx.models import (
    SeatingRequest,
    SeatingResponse,
    HallSeatingResponse,
    StudentSeatingResponse,
    SeatAssignment,
    StudentInfo
)
from services.seating_agentx.utils import generate_csv, get_allocation_statistics

# Configure logging
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/seating", tags=["Seating"])

# Initialize allocator
allocator = SeatingAllocator()


# ============================================================================
# ROLE VERIFICATION DEPENDENCIES
# ============================================================================

def verify_admin_role(authorization: Optional[str] = Header(None)):
    """Verify ADMIN role for seating generation endpoints"""
    if not authorization:
        logger.warning("Seating admin endpoint accessed without authorization")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authorization token required"
        )
    
    if not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authorization format"
        )
    
    token = authorization.replace("Bearer ", "")
    
    try:
        # Parse mock JWT token (format: mock-jwt-<role>-<user_id>)
        parts = token.split("-")
        if len(parts) >= 3 and parts[2].upper() == "ADMIN":
            return {"role": "ADMIN"}
        else:
            logger.warning(f"Non-admin role attempted to access admin seating endpoint")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Access denied. Admin access required."
            )
    except Exception as e:
        logger.error(f"Token validation error: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )


def verify_teacher_role(authorization: Optional[str] = Header(None)):
    """Verify TEACHER role for faculty seating endpoints"""
    if not authorization:
        logger.warning("Seating faculty endpoint accessed without authorization")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authorization token required"
        )
    
    if not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authorization format"
        )
    
    token = authorization.replace("Bearer ", "")
    
    try:
        parts = token.split("-")
        if len(parts) >= 3 and parts[2].upper() == "TEACHER":
            return {"role": "TEACHER"}
        else:
            logger.warning(f"Non-teacher role attempted to access faculty seating endpoint")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Access denied. Faculty access required."
            )
    except Exception as e:
        logger.error(f"Token validation error: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )


def verify_student_role(authorization: Optional[str] = Header(None)):
    """Verify STUDENT role for student seating endpoints"""
    if not authorization:
        logger.warning("Seating student endpoint accessed without authorization")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authorization token required"
        )
    
    if not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authorization format"
        )
    
    token = authorization.replace("Bearer ", "")
    
    try:
        parts = token.split("-")
        if len(parts) >= 3 and parts[2].upper() == "STUDENT":
            return {"role": "STUDENT"}
        else:
            logger.warning(f"Non-student role attempted to access student seating endpoint")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Access denied. Student access required."
            )
    except Exception as e:
        logger.error(f"Token validation error: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )


# ============================================================================
# ADMIN ENDPOINTS
# ============================================================================

@router.post("/generate", response_model=SeatingResponse)
def generate_seating_allocation(request: SeatingRequest):
    """
    Generate seating allocation for an exam.
    
    **NOTE:** Auth disabled for development/testing.
    
    Creates a deterministic department-interleaved seating arrangement
    and persists it to DynamoDB.
    
    - **exam_id**: Unique exam identifier
    - **exam_type**: SEM or CIA
    - **subject**: Subject/Course code for the exam
    - **time_slot**: Exam time slot (1, 2, or 3)
    - **departments**: List of departments (e.g., ["CSE", "ECE", "AIDS"])
    - **years**: List of years (e.g., [1, 2, 3, 4])
    - **halls**: List of hall configurations with hall_id and benches
    - **bench_capacity**: Must be 2 (default)
    
    Returns:
        SeatingResponse with allocation details
    
    Raises:
        400: If validation fails or insufficient benches
        404: If no students found for criteria
        409: If exam_id already exists
        500: If allocation fails
    """
    try:
        logger.info(f"Generating seating allocation for exam: {request.exam_id}")
        response = allocator.generate_allocation(request)
        logger.info(f"Successfully generated seating for {response.allocated_students} students")
        return response
    
    except ValueError as e:
        error_msg = str(e)
        logger.error(f"Validation error: {error_msg}")
        
        # Check for specific error types
        if "already exists" in error_msg:
            # Duplicate exam_id
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail=error_msg
            )
        elif "No students found" in error_msg:
            # No students matching criteria
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=error_msg
            )
        elif "Insufficient benches" in error_msg:
            # Not enough benches for students
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=error_msg
            )
        else:
            # Other validation errors
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=error_msg
            )
    
    except RuntimeError as e:
        logger.error(f"Runtime error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
    
    except Exception as e:
        logger.error(f"Unexpected error generating seating allocation: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to generate seating allocation"
        )



@router.get("/{exam_id}")
def get_seating_allocation(exam_id: str):
    """
    Retrieve complete seating allocation for an exam.
    
    **NOTE:** Auth disabled for development/testing.
    
    Returns JSON with all seat assignments.
    """
    try:
        logger.info(f"Retrieving seating allocation for exam: {exam_id}")
        allocations = allocator.get_allocation(exam_id)
        
        if not allocations:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"No seating allocation found for exam: {exam_id}"
            )
        
        # Get statistics
        stats = get_allocation_statistics(allocations)
        
        return {
            "exam_id": exam_id,
            "allocations": allocations,
            "statistics": stats
        }
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error retrieving seating allocation: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve seating allocation"
        )


@router.get("/{exam_id}/csv")
def get_seating_csv(exam_id: str):
    """
    Download seating allocation as CSV file.
    
    **NOTE:** Auth disabled for development/testing.
    
    CSV Format:
    Hall ID, Bench No, Left Roll, Left Department, Right Roll, Right Department
    """
    try:
        logger.info(f"Generating CSV for exam: {exam_id}")
        allocations = allocator.get_allocation(exam_id)
        
        if not allocations:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"No seating allocation found for exam: {exam_id}"
            )
        
        # Generate CSV content
        csv_content = generate_csv(allocations)
        
        # Return as downloadable CSV file
        return Response(
            content=csv_content,
            media_type="text/csv",
            headers={
                "Content-Disposition": f"attachment; filename=seating_{exam_id}.csv"
            }
        )
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error generating CSV: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to generate CSV"
        )


# ============================================================================
# FACULTY ENDPOINTS
# ============================================================================

@router.get("/{exam_id}/hall/{hall_id}")
def get_hall_seating(exam_id: str, hall_id: str):
    """
    Retrieve seating allocation for a specific hall.
    
    **NOTE:** Auth disabled for development/testing.
    
    Useful for faculty invigilators to see their assigned hall's seating plan.
    """
    try:
        logger.info(f"Retrieving hall seating: exam={exam_id}, hall={hall_id}")
        allocations = allocator.get_hall_allocation(exam_id, hall_id)
        
        if not allocations:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"No seating allocation found for hall: {hall_id} in exam: {exam_id}"
            )
        
        return {
            "exam_id": exam_id,
            "hall_id": hall_id,
            "total_benches": len(allocations),
            "benches": allocations
        }
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error retrieving hall seating: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve hall seating"
        )


# ============================================================================
# STUDENT ENDPOINTS
# ============================================================================

@router.get("/{exam_id}/student/{roll_no}")
def get_student_seating(exam_id: str, roll_no: str):
    """
    Retrieve seat assignment for a specific student.
    
    **NOTE:** Auth disabled for development/testing.
    
    Returns hall_id, bench_no, and seat position (left/right).
    """
    try:
        logger.info(f"Retrieving student seating: exam={exam_id}, roll={roll_no}")
        allocation = allocator.get_student_allocation(exam_id, roll_no)
        
        # Extract student info and position
        seat_position = allocation.pop('seat_position')
        student_key = f"{seat_position}_student"
        student_info = allocation.get(student_key)
        
        return {
            "exam_id": exam_id,
            "student": student_info,
            "hall_id": allocation['hall_id'],
            "bench_no": allocation['bench_no'],
            "seat_position": seat_position
        }
    
    except ValueError as e:
        logger.warning(f"Student seat not found: {e}")
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )
    except Exception as e:
        logger.error(f"Error retrieving student seating: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve student seating"
        )
