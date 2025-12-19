"""
Verification Script - DynamoDB Table Configuration

Checks that environment variables are correctly configured for both tables.
"""

import os
import sys

def verify_config():
    """Verify environment variable configuration"""
    
    print("="*70)
    print("DynamoDB Table Configuration Verification")
    print("="*70)
    
    # Check if we're running in Lambda or local
    is_lambda = os.getenv("AWS_EXECUTION_ENV") is not None
    
    print(f"\nEnvironment: {'AWS Lambda' if is_lambda else 'Local'}")
    print("-"*70)
    
    # Check environment variables
    checks = {
        'STUDENT_TABLE': {
            'value': os.getenv('STUDENT_TABLE'),
            'expected': 'StudX_StudentMaster',
            'purpose': 'Read student data'
        },
        'SEATING_TABLE': {
            'value': os.getenv('SEATING_TABLE'),
            'expected': 'StudX_SeatingAllocations',
            'purpose': 'Write seating allocations'
        },
        'AWS_REGION_NAME': {
            'value': os.getenv('AWS_REGION_NAME'),
            'expected': 'ap-south-2',
            'purpose': 'DynamoDB region'
        }
    }
    
    all_passed = True
    
    for var_name, check in checks.items():
        value = check['value']
        expected = check['expected']
        purpose = check['purpose']
        
        if value:
            if value == expected:
                print(f"✓ {var_name}: {value}")
                print(f"  Purpose: {purpose}")
            else:
                print(f"⚠️  {var_name}: {value} (expected: {expected})")
                print(f"  Purpose: {purpose}")
                all_passed = False
        else:
            print(f"❌ {var_name}: NOT SET")
            print(f"  Expected: {expected}")
            print(f"  Purpose: {purpose}")
            all_passed = False
    
    # Test repository initialization
    print("\n" + "-"*70)
    print("Testing Repository Initialization")
    print("-"*70)
    
    try:
        sys.path.append('d:/studx-backend/backend/src')
        from services.seating_agentx.repository import SeatingRepository, STUDENT_TABLE, SEATING_TABLE
        
        print(f"✓ Repository module loaded")
        print(f"  STUDENT_TABLE: {STUDENT_TABLE}")
        print(f"  SEATING_TABLE: {SEATING_TABLE}")
        
        # Try to initialize (will fail if AWS credentials not available, but that's ok)
        try:
            repo = SeatingRepository()
            print(f"✓ Repository initialized successfully")
        except Exception as e:
            if "credentials" in str(e).lower() or "region" in str(e).lower():
                print(f"⚠️  Repository init failed (AWS credentials issue - expected locally)")
            else:
                print(f"❌ Repository init failed: {e}")
                all_passed = False
                
    except AssertionError as e:
        print(f"❌ Assertion failed: {e}")
        all_passed = False
    except Exception as e:
        print(f"❌ Error loading repository: {e}")
        all_passed = False
    
    # Final verdict
    print("\n" + "="*70)
    if all_passed:
        print("✅ ALL CHECKS PASSED!")
        print("="*70)
        print("\nConfiguration is correct:")
        print("  - STUDENT_TABLE → StudX_StudentMaster (READ)")
        print("  - SEATING_TABLE → StudX_SeatingAllocations (WRITE)")
        print("\nNext Steps:")
        print("  1. Deploy: sam build && sam deploy")
        print("  2. Test: POST /seating/generate")
        print("  3. Verify: Check StudX_SeatingAllocations ItemCount > 0")
    else:
        print("❌ SOME CHECKS FAILED!")
        print("="*70)
        print("\nPlease review the issues above.")
    
    print("="*70)
    
    return all_passed

if __name__ == '__main__':
    success = verify_config()
    sys.exit(0 if success else 1)
