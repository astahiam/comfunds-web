class UserRoles {
  // Basic user roles
  static const String guest = 'guest';
  static const String member = 'member';
  static const String investor = 'investor';
  static const String businessOwner = 'business_owner';
  
  // Admin roles (hierarchical)
  static const String adminComfunds = 'admin_comfunds';      // Super admin
  static const String adminCooperative = 'admin_cooperative'; // Cooperative admin
  static const String umkmBusiness = 'umkm_business';        // UMKM business owner
  
  // Legacy admin role (for backward compatibility)
  static const String admin = 'admin';
  static const String cooperativeAdmin = 'cooperative_admin';

  // All available roles
  static const List<String> allRoles = [
    guest,
    member,
    investor,
    businessOwner,
    adminComfunds,
    adminCooperative,
    umkmBusiness,
    admin,
    cooperativeAdmin,
  ];

  // Role hierarchy (who can assign what)
  static const Map<String, List<String>> roleHierarchy = {
    adminComfunds: [adminCooperative, umkmBusiness, member, investor, businessOwner],
    adminCooperative: [member, investor, businessOwner],
    admin: [member, investor, businessOwner], // Legacy admin
    cooperativeAdmin: [member, investor, businessOwner], // Legacy cooperative admin
  };

  // Role display names
  static const Map<String, String> roleDisplayNames = {
    guest: 'Guest',
    member: 'Member',
    investor: 'Investor',
    businessOwner: 'Business Owner',
    adminComfunds: 'Admin ComFunds',
    adminCooperative: 'Admin Cooperative',
    umkmBusiness: 'UMKM Business',
    admin: 'Admin',
    cooperativeAdmin: 'Cooperative Admin',
  };

  // Role descriptions
  static const Map<String, String> roleDescriptions = {
    guest: 'Guest user with limited access',
    member: 'Basic cooperative member',
    investor: 'User who can invest in projects',
    businessOwner: 'Business owner who can create projects',
    adminComfunds: 'Super administrator with full system access',
    adminCooperative: 'Cooperative administrator managing specific cooperative',
    umkmBusiness: 'UMKM business owner with business management access',
    admin: 'System administrator (legacy)',
    cooperativeAdmin: 'Cooperative administrator (legacy)',
  };

  // Role permissions
  static const Map<String, List<String>> rolePermissions = {
    guest: ['view_public_content'],
    member: ['view_public_content', 'view_cooperative', 'basic_features'],
    investor: ['view_public_content', 'view_cooperative', 'basic_features', 'invest', 'view_portfolio'],
    businessOwner: ['view_public_content', 'view_cooperative', 'basic_features', 'manage_business', 'create_projects'],
    adminComfunds: [
      'view_public_content', 'view_cooperative', 'basic_features', 'invest', 'view_portfolio',
      'manage_business', 'create_projects', 'manage_all_users', 'assign_roles', 'manage_all_cooperatives',
      'manage_all_businesses', 'manage_all_projects', 'manage_all_investments', 'system_settings'
    ],
    adminCooperative: [
      'view_public_content', 'view_cooperative', 'basic_features', 'invest', 'view_portfolio',
      'manage_business', 'create_projects', 'manage_cooperative_users', 'assign_roles',
      'manage_cooperative', 'manage_cooperative_businesses', 'manage_cooperative_projects',
      'manage_cooperative_investments'
    ],
    umkmBusiness: [
      'view_public_content', 'view_cooperative', 'basic_features', 'manage_business',
      'create_projects', 'manage_business_projects', 'view_business_investments'
    ],
    admin: [
      'view_public_content', 'view_cooperative', 'basic_features', 'invest', 'view_portfolio',
      'manage_business', 'create_projects', 'manage_users', 'assign_roles', 'system_settings'
    ],
    cooperativeAdmin: [
      'view_public_content', 'view_cooperative', 'basic_features', 'invest', 'view_portfolio',
      'manage_business', 'create_projects', 'manage_cooperative_users', 'assign_roles',
      'manage_cooperative'
    ],
  };

  // Check if user has permission
  static bool hasPermission(List<String> userRoles, String permission) {
    for (String role in userRoles) {
      if (rolePermissions[role]?.contains(permission) ?? false) {
        return true;
      }
    }
    return false;
  }

  // Get display name for role
  static String getDisplayName(String role) {
    return roleDisplayNames[role] ?? role;
  }

  // Get description for role
  static String getDescription(String role) {
    return roleDescriptions[role] ?? 'No description available';
  }

  // Check if role can assign other roles
  static bool canAssignRole(String userRole, String targetRole) {
    final assignableRoles = roleHierarchy[userRole] ?? [];
    return assignableRoles.contains(targetRole);
  }

  // Get all roles that a user can assign
  static List<String> getAssignableRoles(String userRole) {
    return roleHierarchy[userRole] ?? [];
  }

  // Check if role is admin level
  static bool isAdminLevel(String role) {
    return [
      adminComfunds,
      adminCooperative,
      admin,
      cooperativeAdmin,
    ].contains(role);
  }

  // Check if role is super admin
  static bool isSuperAdmin(String role) {
    return role == adminComfunds;
  }

  // Check if role is cooperative admin
  static bool isCooperativeAdmin(String role) {
    return [
      adminCooperative,
      cooperativeAdmin,
    ].contains(role);
  }
}
