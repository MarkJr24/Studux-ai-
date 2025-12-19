"""
Route Verification Script for StudX Backend

This script verifies that all routes are properly registered in the FastAPI app,
particularly the SeatingAgentX routes.
"""

import sys
sys.path.append('d:/studx-backend/backend/src')

from app import app

def verify_routes():
    """Verify all registered routes in the FastAPI app"""
    
    print("="*70)
    print("StudX Backend - Route Verification")
    print("="*70)
    
    # Get all routes
    routes = []
    for route in app.routes:
        if hasattr(route, 'path') and hasattr(route, 'methods'):
            for method in route.methods:
                if method != 'HEAD':  # Skip HEAD methods
                    routes.append({
                        'method': method,
                        'path': route.path,
                        'name': route.name if hasattr(route, 'name') else 'N/A'
                    })
    
    # Sort routes by path
    routes.sort(key=lambda x: (x['path'], x['method']))
    
    # Print all routes
    print(f"\nTotal Routes: {len(routes)}")
    print("\n" + "-"*70)
    
    # Group by prefix
    route_groups = {}
    for route in routes:
        path = route['path']
        # Extract prefix (first part after /)
        parts = path.split('/')
        prefix = '/' + parts[1] if len(parts) > 1 and parts[1] else '/'
        
        if prefix not in route_groups:
            route_groups[prefix] = []
        route_groups[prefix].append(route)
    
    # Print grouped routes
    for prefix in sorted(route_groups.keys()):
        print(f"\n{prefix.upper()} Routes:")
        print("-"*70)
        for route in route_groups[prefix]:
            print(f"  {route['method']:6} {route['path']}")
    
    # Verify SeatingAgentX routes
    print("\n" + "="*70)
    print("SeatingAgentX Route Verification")
    print("="*70)
    
    seating_routes = [r for r in routes if '/seating' in r['path']]
    
    if not seating_routes:
        print("❌ ERROR: No seating routes found!")
        return False
    
    print(f"\n✓ Found {len(seating_routes)} seating routes:")
    for route in seating_routes:
        print(f"  {route['method']:6} {route['path']}")
    
    # Check for critical routes
    critical_routes = {
        'POST /seating/generate': False,
        'GET /seating/{exam_id}': False,
        'GET /seating/{exam_id}/csv': False,
        'GET /seating/{exam_id}/hall/{hall_id}': False,
        'GET /seating/{exam_id}/student/{roll_no}': False
    }
    
    for route in seating_routes:
        route_key = f"{route['method']} {route['path']}"
        for critical in critical_routes.keys():
            if critical.replace('{exam_id}', '').replace('{hall_id}', '').replace('{roll_no}', '') in route_key:
                critical_routes[critical] = True
    
    print("\n" + "-"*70)
    print("Critical Route Check:")
    print("-"*70)
    
    all_found = True
    for route_name, found in critical_routes.items():
        status = "✓" if found else "❌"
        print(f"  {status} {route_name}")
        if not found:
            all_found = False
    
    # Check root_path configuration
    print("\n" + "="*70)
    print("API Gateway Configuration")
    print("="*70)
    
    root_path = app.root_path if hasattr(app, 'root_path') else None
    if root_path:
        print(f"✓ root_path configured: {root_path}")
        print(f"  OpenAPI URL: {root_path}/openapi.json")
        print(f"  Swagger UI: {root_path}/docs")
    else:
        print("❌ WARNING: root_path not configured (Swagger may not work behind API Gateway)")
    
    # Final verdict
    print("\n" + "="*70)
    if all_found and root_path:
        print("✅ ALL CHECKS PASSED!")
        print("="*70)
        print("\nExpected API Gateway URLs:")
        print("  Base: https://<API_ID>.execute-api.ap-south-2.amazonaws.com/Prod")
        print("  Health: .../Prod/health")
        print("  Seating: .../Prod/seating/generate")
        print("  OpenAPI: .../Prod/openapi.json")
        print("  Swagger: .../Prod/docs")
        return True
    else:
        print("❌ SOME CHECKS FAILED!")
        print("="*70)
        return False

if __name__ == '__main__':
    try:
        success = verify_routes()
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
