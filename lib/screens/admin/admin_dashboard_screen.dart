import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/role_constants.dart';
import '../../widgets/common/app_button.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            color: AppColors.background,
            child: Column(
              children: [
                const SizedBox(height: AppSizes.lg),
                _buildNavItem(
                  icon: Icons.dashboard,
                  title: 'Overview',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.people,
                  title: 'User Management',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.security,
                  title: 'Role Requests',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.analytics,
                  title: 'Role Statistics',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.settings,
                  title: 'System Settings',
                  index: 4,
                ),
                const Spacer(),
                _buildUserInfo(),
                const SizedBox(height: AppSizes.lg),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildUserInfo() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(AppSizes.md),
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: AppShadows.small,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current User',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                user.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                user.email,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Wrap(
                spacing: AppSizes.xs,
                children: user.roles.map((role) => Chip(
                  label: Text(
                    UserRoles.getDisplayName(role),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildUserManagement();
      case 2:
        return _buildRoleRequests();
      case 3:
        return _buildRoleStatistics();
      case 4:
        return _buildSystemSettings();
      default:
        return _buildOverview();
    }
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Overview',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          
          // Statistics Cards
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Users', '1,234', Icons.people)),
              const SizedBox(width: AppSizes.lg),
              Expanded(child: _buildStatCard('Pending Requests', '15', Icons.pending)),
              const SizedBox(width: AppSizes.lg),
              Expanded(child: _buildStatCard('Active Projects', '89', Icons.work)),
              const SizedBox(width: AppSizes.lg),
              Expanded(child: _buildStatCard('Total Investments', '\$2.5M', Icons.trending_up)),
            ],
          ),
          
          const SizedBox(height: AppSizes.xxl),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          
          Row(
            children: [
              Expanded(child: _buildActionCard(
                'Review Role Requests',
                'Approve or reject pending role requests',
                Icons.security,
                () => setState(() => _selectedIndex = 2),
              )),
              const SizedBox(width: AppSizes.lg),
              Expanded(child: _buildActionCard(
                'Manage Users',
                'View and manage user accounts',
                Icons.people,
                () => setState(() => _selectedIndex = 1),
              )),
              const SizedBox(width: AppSizes.lg),
              Expanded(child: _buildActionCard(
                'View Statistics',
                'Analytics and role distribution',
                Icons.analytics,
                () => setState(() => _selectedIndex = 3),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Management',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          
          // Search and Filter
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              DropdownButton<String>(
                value: null,
                hint: const Text('Filter by Role'),
                items: UserRoles.allRoles.map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(UserRoles.getDisplayName(role)),
                )).toList(),
                onChanged: (value) {
                  // TODO: Implement role filtering
                },
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Users Table
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              boxShadow: AppShadows.small,
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusMd),
                      topRight: Radius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.w600))),
                      Expanded(flex: 2, child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600))),
                      Expanded(flex: 2, child: Text('Roles', style: TextStyle(fontWeight: FontWeight.w600))),
                      Expanded(flex: 1, child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                      Expanded(flex: 1, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                    ],
                  ),
                ),
                
                // Sample User Rows
                _buildUserRow('John Doe', 'john@example.com', ['member', 'investor'], 'Active'),
                _buildUserRow('Jane Smith', 'jane@example.com', ['member'], 'Active'),
                _buildUserRow('Bob Wilson', 'bob@example.com', ['business_owner'], 'Pending'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleRequests() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Role Requests',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          
          // Filter Tabs
          Row(
            children: [
              _buildFilterTab('All', true),
              const SizedBox(width: AppSizes.md),
              _buildFilterTab('Pending', false),
              const SizedBox(width: AppSizes.md),
              _buildFilterTab('Approved', false),
              const SizedBox(width: AppSizes.md),
              _buildFilterTab('Rejected', false),
            ],
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Role Requests List
          Column(
            children: [
              _buildRoleRequestCard(
                'John Doe',
                'john@example.com',
                'investor',
                'I want to invest in cooperative projects to support community businesses.',
                'pending',
                '2025-08-30',
              ),
              const SizedBox(height: AppSizes.md),
              _buildRoleRequestCard(
                'Jane Smith',
                'jane@example.com',
                'business_owner',
                'I have a small business and want to create investment opportunities.',
                'pending',
                '2025-08-29',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleStatistics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Role Statistics',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          
          // Role Distribution
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    boxShadow: AppShadows.small,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Role Distribution',
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildRoleStat('Members', 850, 0.68),
                      _buildRoleStat('Investors', 320, 0.26),
                      _buildRoleStat('Business Owners', 45, 0.04),
                      _buildRoleStat('Admins', 12, 0.01),
                      _buildRoleStat('Cooperative Admins', 8, 0.01),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.lg),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    boxShadow: AppShadows.small,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Activity',
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildActivityItem('New member registered', '2 hours ago'),
                      _buildActivityItem('Role request approved', '4 hours ago'),
                      _buildActivityItem('Business owner added', '1 day ago'),
                      _buildActivityItem('Investment made', '2 days ago'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Settings',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              boxShadow: AppShadows.small,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General Settings',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                
                SwitchListTile(
                  title: const Text('Enable Role Requests'),
                  subtitle: const Text('Allow users to request role upgrades'),
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement setting toggle
                  },
                ),
                
                SwitchListTile(
                  title: const Text('Auto-approve Basic Roles'),
                  subtitle: const Text('Automatically approve member role requests'),
                  value: false,
                  onChanged: (value) {
                    // TODO: Implement setting toggle
                  },
                ),
                
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Send email notifications for role changes'),
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement setting toggle
                  },
                ),
                
                const SizedBox(height: AppSizes.lg),
                
                Text(
                  'Security Settings',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                
                SwitchListTile(
                  title: const Text('Require Admin Code'),
                  subtitle: const Text('Require admin code for admin registration'),
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement setting toggle
                  },
                ),
                
                SwitchListTile(
                  title: const Text('Two-Factor Authentication'),
                  subtitle: const Text('Require 2FA for admin accounts'),
                  value: false,
                  onChanged: (value) {
                    // TODO: Implement setting toggle
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const Spacer(),
              Text(
                value,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: AppShadows.small,
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: AppSizes.md),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow(String name, String email, List<String> roles, String status) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(name)),
          Expanded(flex: 2, child: Text(email)),
          Expanded(
            flex: 2,
            child: Wrap(
              spacing: AppSizes.xs,
              children: roles.map((role) => Chip(
                label: Text(
                  UserRoles.getDisplayName(role),
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )).toList(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
              decoration: BoxDecoration(
                color: status == 'Active' ? AppColors.success : AppColors.warning,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Text(
                status,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () {
                    // TODO: Implement edit user
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 16),
                  onPressed: () {
                    // TODO: Implement delete user
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement filter
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleRequestCard(String name, String email, String requestedRole, String reason, String status, String date) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      email,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
                decoration: BoxDecoration(
                  color: status == 'pending' ? AppColors.warning : 
                         status == 'approved' ? AppColors.success : AppColors.error,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Requesting Role: ${UserRoles.getDisplayName(requestedRole)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            reason,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Text(
                'Requested: $date',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (status == 'pending') ...[
                AppButton(
                  text: 'Approve',
                  onPressed: () {
                    // TODO: Implement approve
                  },
                ),
                const SizedBox(width: AppSizes.sm),
                AppButton(
                  text: 'Reject',
                  onPressed: () {
                    // TODO: Implement reject
                  },
                  backgroundColor: AppColors.error,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleStat(String role, int count, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(role),
          ),
          Expanded(
            flex: 1,
            child: Text(
              count.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${(percentage * 100).toInt()}%',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(activity),
          ),
          Text(
            time,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
