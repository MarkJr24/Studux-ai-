"""
Test Script for SeatingAgentX Endpoints (No Auth Required)

This script tests all SeatingAgentX endpoints without authentication.
Auth has been disabled for development/testing purposes.
"""

import requests
import json

# Configuration
BASE_URL = "http://localhost:3000"  # For local testing with SAM local
# BASE_URL = "https://<API_ID>.execute-api.ap-south-2.amazonaws.com/Prod"  # For deployed API

def test_generate_allocation():
    """Test POST /seating/generate without auth"""
    print("\n" + "="*70)
    print("TEST 1: Generate Seating Allocation (No Auth)")
    print("="*70)
    
    url = f"{BASE_URL}/seating/generate"
    
    payload = {
        "exam_id": "TEST_2024_NOAUTH",
        "exam_type": "SEM",
        "subject": "Python Programming",
        "time_slot": 1,
        "departments": ["CSE", "ECE"],
        "years": [1, 2],
        "halls": [
            {"hall_id": "HALL_A", "benches": 20}
        ],
        "bench_capacity": 2
    }
    
    print(f"\nPOST {url}")
    print(f"Payload: {json.dumps(payload, indent=2)}")
    
    try:
        response = requests.post(
            url,
            json=payload,
            headers={"Content-Type": "application/json"}
            # NOTE: No Authorization header!
        )
        
        print(f"\nStatus Code: {response.status_code}")
        
        if response.status_code == 200:
            print("✅ SUCCESS: Allocation created without auth!")
            result = response.json()
            print(f"\nAllocated Students: {result.get('allocated_students')}")
            print(f"Total Benches: {result.get('total_benches')}")
            print(f"Message: {result.get('message')}")
        elif response.status_code == 404:
            print("⚠️  No students found (expected if database is empty)")
            print(f"Response: {response.json()}")
        elif response.status_code == 409:
            print("⚠️  Exam ID already exists (expected if run multiple times)")
            print(f"Response: {response.json()}")
        else:
            print(f"❌ FAILED: {response.status_code}")
            print(f"Response: {response.text}")
            
    except Exception as e:
        print(f"❌ ERROR: {e}")

def test_get_allocation():
    """Test GET /seating/{exam_id} without auth"""
    print("\n" + "="*70)
    print("TEST 2: Get Seating Allocation (No Auth)")
    print("="*70)
    
    exam_id = "TEST_2024_NOAUTH"
    url = f"{BASE_URL}/seating/{exam_id}"
    
    print(f"\nGET {url}")
    
    try:
        response = requests.get(url)
        
        print(f"\nStatus Code: {response.status_code}")
        
        if response.status_code == 200:
            print("✅ SUCCESS: Retrieved allocation without auth!")
            result = response.json()
            print(f"\nExam ID: {result.get('exam_id')}")
            print(f"Total Allocations: {len(result.get('allocations', []))}")
        elif response.status_code == 404:
            print("⚠️  Allocation not found (expected if not created yet)")
            print(f"Response: {response.json()}")
        else:
            print(f"❌ FAILED: {response.status_code}")
            print(f"Response: {response.text}")
            
    except Exception as e:
        print(f"❌ ERROR: {e}")

def test_health_check():
    """Test health endpoint"""
    print("\n" + "="*70)
    print("TEST 0: Health Check")
    print("="*70)
    
    url = f"{BASE_URL}/health"
    
    print(f"\nGET {url}")
    
    try:
        response = requests.get(url)
        
        print(f"\nStatus Code: {response.status_code}")
        
        if response.status_code == 200:
            print("✅ SUCCESS: API is healthy!")
            print(f"Response: {response.json()}")
        else:
            print(f"❌ FAILED: {response.status_code}")
            print(f"Response: {response.text}")
            
    except Exception as e:
        print(f"❌ ERROR: {e}")
        print("\nMake sure the API is running:")
        print("  Local: sam local start-api")
        print("  Deployed: Check API Gateway URL")

if __name__ == '__main__':
    print("="*70)
    print("SeatingAgentX - No Auth Testing")
    print("="*70)
    print(f"\nBase URL: {BASE_URL}")
    print("\n⚠️  NOTE: These endpoints have auth disabled for development!")
    
    # Run tests
    test_health_check()
    test_generate_allocation()
    test_get_allocation()
    
    print("\n" + "="*70)
    print("Testing Complete")
    print("="*70)
    print("\nNext Steps:")
    print("1. If testing locally: sam build && sam local start-api")
    print("2. If testing deployed: Update BASE_URL with your API Gateway URL")
    print("3. Re-enable auth before production deployment!")
