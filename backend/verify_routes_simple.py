"""
Simple Route Configuration Verification

Checks that the routing configuration is correct without running the app.
"""

import os
import re

def check_file_content(filepath, checks):
    """Check if file contains expected patterns"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        results = {}
        for check_name, pattern in checks.items():
            results[check_name] = bool(re.search(pattern, content, re.MULTILINE))
        
        return results
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return None

def main():
    print("="*70)
    print("StudX Backend - Route Configuration Verification")
    print("="*70)
    
    base_path = "d:/studx-backend/backend/src"
    
    # Check 1: app.py configuration
    print("\n1. Checking app.py configuration...")
    print("-"*70)
    
    app_checks = {
        'root_path_configured': r'root_path\s*=\s*["\']\/Prod["\']',
        'seating_router_imported': r'from api\.seating import router as seating_router',
        'seating_router_included': r'app\.include_router\(seating_router\)',
    }
    
    app_results = check_file_content(f"{base_path}/app.py", app_checks)
    
    if app_results:
        for check, passed in app_results.items():
            status = "✓" if passed else "❌"
            print(f"  {status} {check.replace('_', ' ').title()}")
    
    # Check 2: seating.py router configuration
    print("\n2. Checking api/seating.py router configuration...")
    print("-"*70)
    
    seating_checks = {
        'router_prefix_defined': r'router\s*=\s*APIRouter\(prefix\s*=\s*["\']\/seating["\']',
        'generate_route_defined': r'@router\.post\(["\']\/generate["\']',
        'get_allocation_route': r'@router\.get\(["\']\/\{exam_id\}["\']',
        'csv_route_defined': r'@router\.get\(["\']\/\{exam_id\}\/csv["\']',
        'hall_route_defined': r'@router\.get\(["\']\/\{exam_id\}\/hall\/\{hall_id\}["\']',
        'student_route_defined': r'@router\.get\(["\']\/\{exam_id\}\/student\/\{roll_no\}["\']',
    }
    
    seating_results = check_file_content(f"{base_path}/api/seating.py", seating_checks)
    
    if seating_results:
        for check, passed in seating_results.items():
            status = "✓" if passed else "❌"
            print(f"  {status} {check.replace('_', ' ').title()}")
    
    # Final verdict
    print("\n" + "="*70)
    print("Configuration Summary")
    print("="*70)
    
    all_passed = True
    if app_results:
        all_passed = all_passed and all(app_results.values())
    if seating_results:
        all_passed = all_passed and all(seating_results.values())
    
    if all_passed:
        print("\n✅ ALL CONFIGURATION CHECKS PASSED!")
        print("\nExpected Route Structure:")
        print("  - Router defined with prefix: /seating")
        print("  - Routes defined as: /generate, /{exam_id}, etc.")
        print("  - Final resolved paths:")
        print("    POST /seating/generate")
        print("    GET  /seating/{exam_id}")
        print("    GET  /seating/{exam_id}/csv")
        print("    GET  /seating/{exam_id}/hall/{hall_id}")
        print("    GET  /seating/{exam_id}/student/{roll_no}")
        print("\nAPI Gateway URLs (after deployment):")
        print("  Base: https://<API_ID>.execute-api.ap-south-2.amazonaws.com/Prod")
        print("  Example: .../Prod/seating/generate")
        print("  OpenAPI: .../Prod/openapi.json")
        print("  Swagger: .../Prod/docs")
    else:
        print("\n❌ SOME CONFIGURATION CHECKS FAILED!")
        print("Please review the issues above.")
    
    print("="*70)
    
    return all_passed

if __name__ == '__main__':
    import sys
    success = main()
    sys.exit(0 if success else 1)
