"""
Authentication Service
Handles authentication logic, token generation, and password management
"""
from typing import Optional, Dict, Any
import logging

# Configure logging
logger = logging.getLogger(__name__)

# HARDCODED USERS FOR TESTING - IN-MEMORY DATABASE
# DO NOT USE IN PRODUCTION
HARDCODED_USERS = {
    # STUDENTS (10 users)
    "student1@studentms.com": {
        "user_id": "STU001",
        "name": "Student One",
        "email": "student1@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    "student2@studentms.com": {
        "user_id": "STU002",
        "name": "Student Two",
        "email": "student2@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    "student3@studentms.com": {
        "user_id": "STU003",
        "name": "Student Three",
        "email": "student3@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    "student4@studentms.com": {
        "user_id": "STU004",
        "name": "Student Four",
        "email": "student4@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    "student5@studentms.com": {
        "user_id": "STU005",
        "name": "Student Five",
        "email": "student5@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    "student6@studentms.com": {
        "user_id": "STU006",
        "name": "Student Six",
        "email": "student6@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    "student7@studentms.com": {
        "user_id": "STU007",
        "name": "Student Seven",
        "email": "student7@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    "student8@studentms.com": {
        "user_id": "STU008",
        "name": "Student Eight",
        "email": "student8@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    "student9@studentms.com": {
        "user_id": "STU009",
        "name": "Student Nine",
        "email": "student9@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    "student10@studentms.com": {
        "user_id": "STU010",
        "name": "Student Ten",
        "email": "student10@studentms.com",
        "password": "Student@123",
        "role": "STUDENT"
    },
    
    # TEACHERS (10 users)
    "teacher1@studentms.com": {
        "user_id": "TCH001",
        "name": "Teacher One",
        "email": "teacher1@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    "teacher2@studentms.com": {
        "user_id": "TCH002",
        "name": "Teacher Two",
        "email": "teacher2@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    "teacher3@studentms.com": {
        "user_id": "TCH003",
        "name": "Teacher Three",
        "email": "teacher3@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    "teacher4@studentms.com": {
        "user_id": "TCH004",
        "name": "Teacher Four",
        "email": "teacher4@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    "teacher5@studentms.com": {
        "user_id": "TCH005",
        "name": "Teacher Five",
        "email": "teacher5@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    "teacher6@studentms.com": {
        "user_id": "TCH006",
        "name": "Teacher Six",
        "email": "teacher6@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    "teacher7@studentms.com": {
        "user_id": "TCH007",
        "name": "Teacher Seven",
        "email": "teacher7@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    "teacher8@studentms.com": {
        "user_id": "TCH008",
        "name": "Teacher Eight",
        "email": "teacher8@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    "teacher9@studentms.com": {
        "user_id": "TCH009",
        "name": "Teacher Nine",
        "email": "teacher9@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    "teacher10@studentms.com": {
        "user_id": "TCH010",
        "name": "Teacher Ten",
        "email": "teacher10@studentms.com",
        "password": "Teacher@123",
        "role": "TEACHER"
    },
    
    # ADMINS (10 users)
    "admin1@studentms.com": {
        "user_id": "ADM001",
        "name": "Admin One",
        "email": "admin1@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    },
    "admin2@studentms.com": {
        "user_id": "ADM002",
        "name": "Admin Two",
        "email": "admin2@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    },
    "admin3@studentms.com": {
        "user_id": "ADM003",
        "name": "Admin Three",
        "email": "admin3@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    },
    "admin4@studentms.com": {
        "user_id": "ADM004",
        "name": "Admin Four",
        "email": "admin4@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    },
    "admin5@studentms.com": {
        "user_id": "ADM005",
        "name": "Admin Five",
        "email": "admin5@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    },
    "admin6@studentms.com": {
        "user_id": "ADM006",
        "name": "Admin Six",
        "email": "admin6@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    },
    "admin7@studentms.com": {
        "user_id": "ADM007",
        "name": "Admin Seven",
        "email": "admin7@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    },
    "admin8@studentms.com": {
        "user_id": "ADM008",
        "name": "Admin Eight",
        "email": "admin8@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    },
    "admin9@studentms.com": {
        "user_id": "ADM009",
        "name": "Admin Nine",
        "email": "admin9@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    },
    "admin10@studentms.com": {
        "user_id": "ADM010",
        "name": "Admin Ten",
        "email": "admin10@studentms.com",
        "password": "Admin@123",
        "role": "ADMIN"
    }
}


class AuthService:
    """Authentication service for user login and token management"""

    @staticmethod
    def authenticate_user(email: str, password: str) -> Optional[Dict[str, Any]]:
        """
        Authenticate user with email and password
        
        Args:
            email: User's email address
            password: User's password
            
        Returns:
            User dict if authentication successful, None otherwise
        """
        # Normalize email to lowercase
        email = email.lower().strip()
        
        # Check if user exists
        if email not in HARDCODED_USERS:
            logger.warning(f"Login failed - Email not found: {email}")
            return None
        
        user = HARDCODED_USERS[email]
        
        # Verify password
        if user["password"] != password:
            logger.warning(f"Login failed - Invalid password for: {email}")
            return None
        
        # Authentication successful
        logger.info(f"Login successful - User: {email}, Role: {user['role']}")
        
        # Return user data without password
        return {
            "user_id": user["user_id"],
            "name": user["name"],
            "email": user["email"],
            "role": user["role"]
        }

    @staticmethod
    def create_mock_token(user_id: str, role: str) -> str:
        """
        Create a mock JWT token for testing
        
        Args:
            user_id: User's unique identifier
            role: User's role
            
        Returns:
            Mock JWT token string
        """
        # Create a simple mock token - NOT FOR PRODUCTION
        return f"mock-jwt-token-{user_id}-{role}"

    @staticmethod
    def get_all_users() -> Dict[str, Dict[str, Any]]:
        """
        Get all registered users (for testing/debugging only)
        
        Returns:
            Dictionary of all users
        """
        return HARDCODED_USERS

