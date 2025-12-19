"""
StudX Student Master Data Seeding Script

Loads student data from JSON files and inserts into DynamoDB.
Supports ECE, AIDS, and CSE departments with batch operations.
"""

import json
import logging
import os
from pathlib import Path
from typing import Dict, List

import boto3
from botocore.exceptions import ClientError

# Configuration
TABLE_NAME = "StudX_StudentMaster"
REGION = "ap-south-2"
DATA_DIR = Path(__file__).parent / "data"
DEPARTMENTS = ["ece", "aids", "cse"]

# Logging setup
logging.basicConfig(
    level=logging.INFO,
    format="%(message)s"
)
logger = logging.getLogger(__name__)


def load_department_data(dept_file: Path) -> Dict:
    """Load student data from JSON file."""
    with open(dept_file, "r", encoding="utf-8") as f:
        return json.load(f)


def transform_to_dynamodb_item(
    student: Dict,
    department: str,
    year: int
) -> Dict:
    """
    Transform tabular student record to DynamoDB item format.
    
    Args:
        student: Dict with keys: roll, name, email
        department: Department code (ECE, AIDS, CSE)
        year: Academic year (1-4)
    
    Returns:
        DynamoDB item with pk, sk, and attributes
    """
    roll_no = student["roll"]
    
    return {
        "pk": "STUDENT",
        "sk": f"{department}#{year}#{roll_no}",
        "roll_no": roll_no,
        "name": student["name"],
        "email": student["email"],
        "department": department,
        "year": year,
        "role": "STUDENT"
    }


def seed_department(
    table,
    dept_name: str,
    dept_data: Dict
) -> int:
    """
    Seed all students for a single department using batch operations.
    
    Args:
        table: DynamoDB table resource
        dept_name: Department name (ECE, AIDS, CSE)
        dept_data: Loaded JSON data for the department
    
    Returns:
        Total number of students inserted
    """
    department = dept_data["department"]
    years_data = dept_data["years"]
    
    logger.info(f"📥 Seeding department: {department}")
    
    inserted_count = 0
    
    with table.batch_writer() as batch:
        for year_str, students in years_data.items():
            year = int(year_str)
            
            for student in students:
                item = transform_to_dynamodb_item(student, department, year)
                batch.put_item(Item=item)
                inserted_count += 1
    
    logger.info(f"✅ Inserted {inserted_count} students for {department}")
    return inserted_count


def seed_students():
    """Main seeding function."""
    logger.info("🚀 Starting Student Master Seeding")
    logger.info("")
    
    # Initialize DynamoDB resource
    dynamodb = boto3.resource("dynamodb", region_name=REGION)
    table = dynamodb.Table(TABLE_NAME)
    
    # Verify table exists
    try:
        table.load()
    except ClientError as e:
        if e.response["Error"]["Code"] == "ResourceNotFoundException":
            logger.error(f"❌ Table {TABLE_NAME} does not exist in region {REGION}")
            logger.error("Run 'sam deploy' first to create the table")
            raise
        else:
            raise
    
    total_inserted = 0
    
    # Process each department
    for dept in DEPARTMENTS:
        dept_file = DATA_DIR / f"{dept}_students.json"
        
        if not dept_file.exists():
            logger.warning(f"⚠️  File not found: {dept_file}")
            continue
        
        dept_data = load_department_data(dept_file)
        count = seed_department(table, dept, dept_data)
        total_inserted += count
        logger.info("")
    
    logger.info(f"🎉 All student data seeded successfully")
    logger.info(f"📊 Total records inserted: {total_inserted}")


if __name__ == "__main__":
    seed_students()
