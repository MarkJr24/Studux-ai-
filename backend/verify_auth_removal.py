"""
Verification Script - Auth Removal for SeatingAgentX

Checks that authorization dependencies have been removed from all seating endpoints.
"""

import os
import re

def check_auth_removal():
    """Verify that auth dependencies are removed from seating endpoints"""
    
    print("="*70)
    print("SeatingAgentX - Auth Removal Verification")
    print("="*70)
    
    seating_file = "d:/studx-backend/backend/src/api/seating.py"
    
    if not os.path.exists(seating_file):
        print(f"❌ ERROR: File not found: {seating_file}")
        return False
    
    with open(seating_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check for removed dependencies
    checks = {
        'POST /generate': {
            'pattern': r'@router\.post\(["\']\/generate["\'].*dependencies=',
            'should_exist': False,
            'description': 'Generate allocation endpoint should NOT have dependencies'
        },
        'GET /{exam_id}': {
            'pattern': r'@router\.get\(["\']\/\{exam_id\}["\'].*dependencies=',
            'should_exist': False,
            'description': 'Get allocation endpoint should NOT have dependencies'
        },
        'GET /{exam_id}/csv': {
            'pattern': r'@router\.get\(["\']\/\{exam_id\}\/csv["\'].*dependencies=',
            'should_exist': False,
            'description': 'CSV endpoint should NOT have dependencies'
        },
        'GET /{exam_id}/hall/{hall_id}': {
            'pattern': r'@router\.get\(["\']\/\{exam_id\}\/hall\/\{hall_id\}["\'].*dependencies=',
            'should_exist': False,
            'description': 'Hall endpoint should NOT have dependencies'
        },
        'GET /{exam_id}/student/{roll_no}': {
            'pattern': r'@router\.get\(["\']\/\{exam_id\}\/student\/\{roll_no\}["\'].*dependencies=',
            'should_exist': False,
            'description': 'Student endpoint should NOT have dependencies'
        }
    }
    
    print("\nChecking endpoint configurations...")
    print("-"*70)
    
    all_passed = True
    
    for endpoint, check in checks.items():
        pattern = check['pattern']
        should_exist = check['should_exist']
        description = check['description']
        
        found = bool(re.search(pattern, content, re.MULTILINE))
        
        if should_exist:
            passed = found
            status = "✓" if passed else "❌"
        else:
            passed = not found
            status = "✓" if passed else "❌"
        
        print(f"{status} {endpoint}")
        print(f"   {description}")
        
        if not passed:
            all_passed = False
            if found and not should_exist:
                print(f"   ⚠️  WARNING: Auth dependency still present!")
    
    # Check for development notes in docstrings
    print("\n" + "-"*70)
    print("Checking documentation updates...")
    print("-"*70)
    
    dev_note_pattern = r'Auth disabled for development'
    dev_notes_found = len(re.findall(dev_note_pattern, content, re.IGNORECASE))
    
    if dev_notes_found >= 5:
        print(f"✓ Found {dev_notes_found} development notes in docstrings")
    else:
        print(f"⚠️  Only found {dev_notes_found} development notes (expected 5)")
        all_passed = False
    
    # Final verdict
    print("\n" + "="*70)
    if all_passed:
        print("✅ ALL CHECKS PASSED!")
        print("="*70)
        print("\nSeatingAgentX endpoints are now accessible without auth.")
        print("\nNext Steps:")
        print("1. Deploy: sam build && sam deploy")
        print("2. Test: python test_seating_noauth.py")
        print("3. Verify: curl POST /seating/generate (no auth header)")
        print("\n⚠️  REMEMBER: Re-enable auth before production deployment!")
    else:
        print("❌ SOME CHECKS FAILED!")
        print("="*70)
        print("\nPlease review the issues above.")
    
    print("="*70)
    
    return all_passed

if __name__ == '__main__':
    import sys
    success = check_auth_removal()
    sys.exit(0 if success else 1)
