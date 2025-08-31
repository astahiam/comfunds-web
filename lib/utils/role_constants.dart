class UserRoles {
  // Core roles
  static const String guest = 'guest';
  static const String member = 'member';
  static const String investor = 'investor';
  static const String businessOwner = 'business_owner';
  static const String admin = 'admin';
  static const String cooperativeAdmin = 'cooperative_admin';

  // All available roles
  static const List<String> allRoles = [
    guest,
    member,
    investor,
    businessOwner,
    admin,
    cooperativeAdmin,
  ];

  // Role hierarchy (from lowest to highest)
  static const List<String> roleHierarchy = [
    guest,
    member,
    investor,
    businessOwner,
    cooperativeAdmin,
    admin,
  ];

  // Role display names
  static const Map<String, String> roleDisplayNames = {
    guest: 'Guest',
    member: 'Member',
    investor: 'Investor',
    businessOwner: 'Business Owner',
    admin: 'System Administrator',
    cooperativeAdmin: 'Cooperative Administrator',
  };

  // Role descriptions
  static const Map<String, String> roleDescriptions = {
    guest: 'Unauthenticated user with limited access',
    member: 'Basic cooperative member with standard access',
    investor: 'Member who can invest in projects',
    businessOwner: 'Member who owns and manages businesses',
    admin: 'System administrator with full access',
    cooperativeAdmin: 'Cooperative administrator with oversight capabilities',
  };

  // Role permissions
  static const Map<String, List<String>> rolePermissions = {
    guest: [
      'view_landing_page',
      'browse_public_info',
      'register_account',
    ],
    member: [
      'view_landing_page',
      'browse_public_info',
      'register_account',
      'access_dashboard',
      'view_profile',
      'edit_profile',
      'view_projects',
      'view_cooperative_info',
    ],
    investor: [
      'view_landing_page',
      'browse_public_info',
      'register_account',
      'access_dashboard',
      'view_profile',
      'edit_profile',
      'view_projects',
      'view_cooperative_info',
      'browse_investments',
      'make_investments',
      'view_portfolio',
      'track_returns',
      'view_investment_analytics',
    ],
    businessOwner: [
      'view_landing_page',
      'browse_public_info',
      'register_account',
      'access_dashboard',
      'view_profile',
      'edit_profile',
      'view_projects',
      'view_cooperative_info',
      'register_business',
      'create_projects',
      'manage_projects',
      'upload_documents',
      'track_project_performance',
    ],
    cooperativeAdmin: [
      'view_landing_page',
      'browse_public_info',
      'register_account',
      'access_dashboard',
      'view_profile',
      'edit_profile',
      'view_projects',
      'view_cooperative_info',
      'manage_cooperative',
      'approve_members',
      'manage_roles',
      'view_cooperative_analytics',
      'manage_cooperative_projects',
      'approve_businesses',
      'manage_profit_distribution',
    ],
    admin: [
      'view_landing_page',
      'browse_public_info',
      'register_account',
      'access_dashboard',
      'view_profile',
      'edit_profile',
      'view_projects',
      'view_cooperative_info',
      'manage_cooperative',
      'approve_members',
      'manage_roles',
      'view_cooperative_analytics',
      'manage_cooperative_projects',
      'approve_businesses',
      'manage_profit_distribution',
      'system_administration',
      'user_management',
      'system_configuration',
      'financial_oversight',
      'system_monitoring',
      'role_management',
      'approve_role_requests',
    ],
  };

  // Check if user has permission
  static bool hasPermission(List<String> userRoles, String permission) {
    for (String role in userRoles) {
      if (rolePermissions[role]?.contains(permission) == true) {
        return true;
      }
    }
    return false;
  }

  // Get all permissions for user roles
  static List<String> getAllPermissions(List<String> userRoles) {
    Set<String> permissions = {};
    for (String role in userRoles) {
      if (rolePermissions[role] != null) {
        permissions.addAll(rolePermissions[role]!);
      }
    }
    return permissions.toList();
  }

  // Check if role can be upgraded to target role
  static bool canUpgradeRole(String currentRole, String targetRole) {
    int currentIndex = roleHierarchy.indexOf(currentRole);
    int targetIndex = roleHierarchy.indexOf(targetRole);
    
    if (currentIndex == -1 || targetIndex == -1) {
      return false;
    }
    
    return targetIndex > currentIndex;
  }

  // Get roles that can be upgraded to
  static List<String> getUpgradeableRoles(List<String> currentRoles) {
    List<String> upgradeable = [];
    
    for (String targetRole in allRoles) {
      bool canUpgrade = false;
      for (String currentRole in currentRoles) {
        if (canUpgradeRole(currentRole, targetRole)) {
          canUpgrade = true;
          break;
        }
      }
      if (canUpgrade && !currentRoles.contains(targetRole)) {
        upgradeable.add(targetRole);
      }
    }
    
    return upgradeable;
  }

  // Get role display name
  static String getDisplayName(String role) {
    return roleDisplayNames[role] ?? role;
  }

  // Get role description
  static String getDescription(String role) {
    return roleDescriptions[role] ?? 'No description available';
  }
}
