"""
SeatingAgentX Service Layer
Deterministic exam seating allocation system for StudX
"""

from .allocator import SeatingAllocator
from .models import (
    HallConfig,
    SeatingRequest,
    SeatingResponse,
    SeatAssignment,
    StudentInfo
)

__all__ = [
    "SeatingAllocator",
    "HallConfig",
    "SeatingRequest",
    "SeatingResponse",
    "SeatAssignment",
    "StudentInfo"
]

