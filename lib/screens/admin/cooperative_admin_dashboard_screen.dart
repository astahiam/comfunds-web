import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cooperative_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/investment_provider.dart';
import '../../utils/constants.dart';
import '../../utils/role_constants.dart';
import '../../models/cooperative.dart';
import '../../models/business.dart';
import '../../models/project.dart';
import '../../models/investment.dart';
import '../../models/user.dart';

class CooperativeAdminDashboardScreen extends StatefulWidget {
  const CooperativeAdminDashboardScreen({super.key});

  @override
  State<CooperativeAdminDashboardScreen> createState() => _CooperativeAdminDashboardScreenState();
}

class _CooperativeAdminDashboardScreenState extends State<CooperativeAdminDashboardScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final cooperativeProvider = Provider.of<CooperativeProvider>(context, listen: false);
      final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      final investmentProvider = Provider.of<InvestmentProvider>(context, listen: false);
      
      await Future.wait([
        cooperativeProvider.fetchCooperatives(),
        businessProvider.fetchBusinesses(),
        projectProvider.fetchProjects(),
        investmentProvider.fetchInvestments(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooperative Admin Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Sidebar Navigation
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard),
                      label: Text('Overview'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.business),
                      label: Text('Cooperatives'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.store),
                      label: Text('UMKM Businesses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.work),
                      label: Text('Projects'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.trending_up),
                      label: Text('Investments'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people),
                      label: Text('User Management'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                
                // Main Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildCooperatives();
      case 2:
        return _buildUMKMBusinesses();
      case 3:
        return _buildProjects();
      case 4:
        return _buildInvestments();
      case 5:
        return _buildUserManagement();
      case 6:
        return _buildSettings();
      default:
        return _buildOverview();
    }
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Statistics Cards
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Cooperatives', '5', Icons.business, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Total UMKM Businesses', '12', Icons.store, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Active Projects', '8', Icons.work, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Total Investments', '25', Icons.trending_up, Colors.purple)),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Recent Activity
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildRecentActivityList(),
          
          const SizedBox(height: 32),
          
          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Create Cooperative',
                  'Add a new cooperative',
                  Icons.add_business,
                  Colors.blue,
                  () => _showCreateCooperativeDialog(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  'Assign User Role',
                  'Assign roles to users',
                  Icons.person_add,
                  Colors.green,
                  () => _showAssignRoleDialog(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  'View Reports',
                  'Generate system reports',
                  Icons.assessment,
                  Colors.orange,
                  () => _showReportsDialog(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(
                index % 3 == 0 ? Icons.person_add : index % 3 == 1 ? Icons.business : Icons.work,
                color: AppColors.primary,
              ),
            ),
            title: Text('Activity ${index + 1}'),
            subtitle: Text('Description of activity ${index + 1}'),
            trailing: Text('${index + 1}h ago'),
          );
        },
      ),
    );
  }

  Widget _buildCooperatives() {
    return Consumer<CooperativeProvider>(
      builder: (context, provider, child) {
        final cooperatives = provider.cooperatives;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cooperatives Management',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateCooperativeDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Cooperative'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              if (cooperatives.isEmpty)
                const Center(
                  child: Text(
                    'No cooperatives found',
                    style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cooperatives.length,
                  itemBuilder: (context, index) {
                    final cooperative = cooperatives[index];
                    return _buildCooperativeCard(cooperative);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCooperativeCard(Cooperative cooperative) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            cooperative.name[0].toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(cooperative.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cooperative.address),
            Text('Active: ${cooperative.isActive ? "Yes" : "No"}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditCooperativeDialog(cooperative);
            } else if (value == 'delete') {
              _showDeleteCooperativeDialog(cooperative);
            }
          },
        ),
      ),
    );
  }

  Widget _buildUMKMBusinesses() {
    return Consumer<BusinessProvider>(
      builder: (context, provider, child) {
        final businesses = provider.businesses;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'UMKM Businesses Management',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateBusinessDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Business'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              if (businesses.isEmpty)
                const Center(
                  child: Text(
                    'No businesses found',
                    style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: businesses.length,
                  itemBuilder: (context, index) {
                    final business = businesses[index];
                    return _buildBusinessCard(business);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBusinessCard(Business business) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            business.name[0].toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(business.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(business.description ?? 'No description'),
            Text('Type: ${business.businessType}'),
            Text('Status: ${business.approvalStatus}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'approve',
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Approve', style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditBusinessDialog(business);
            } else if (value == 'approve') {
              _approveBusiness(business);
            } else if (value == 'delete') {
              _showDeleteBusinessDialog(business);
            }
          },
        ),
      ),
    );
  }

  Widget _buildProjects() {
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        final projects = provider.projects;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Projects Management',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateProjectDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              if (projects.isEmpty)
                const Center(
                  child: Text(
                    'No projects found',
                    style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return _buildProjectCard(project);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            project.title[0].toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(project.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.description),
            Text('Goal: \$${project.fundingGoal.toStringAsFixed(0)}'),
            Text('Current: \$${project.currentFunding.toStringAsFixed(0)}'),
            Text('Progress: ${project.fundingProgress.toStringAsFixed(1)}%'),
            Text('Status: ${project.status.toUpperCase()}'),
            if (project.fundingDeadline != null)
              Text('Deadline: ${project.fundingDeadline!.toLocal().toString().split(' ')[0]}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            final items = <PopupMenuItem>[];
            
            // Edit option for all projects
            items.add(const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ));
            
            // Approval actions based on project status
            if (project.isSubmitted) {
              items.add(const PopupMenuItem(
                value: 'approve',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Approve'),
                  ],
                ),
              ));
              items.add(const PopupMenuItem(
                value: 'reject',
                child: Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Reject'),
                  ],
                ),
              ));
            }
            
            // Investment actions for approved projects
            if (project.isApproved) {
              items.add(const PopupMenuItem(
                value: 'start_investment',
                child: Row(
                  children: [
                    Icon(Icons.play_circle, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Start Investment'),
                  ],
                ),
              ));
            }
            
            // Close funding for active projects
            if (project.isActive) {
              items.add(const PopupMenuItem(
                value: 'close',
                child: Row(
                  children: [
                    Icon(Icons.stop_circle, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Close Funding'),
                  ],
                ),
              ));
            }
            
            // View details for all projects
            items.add(const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ));
            
            // Delete option for draft projects only
            if (project.isDraft) {
              items.add(const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ));
            }
            
            return items;
          },
          onSelected: (value) async {
            switch (value) {
              case 'edit':
                _showEditProjectDialog(project);
                break;
              case 'approve':
                await _approveProject(project);
                break;
              case 'reject':
                _showRejectProjectDialog(project);
                break;
              case 'start_investment':
                await _startInvestment(project);
                break;
              case 'close':
                await _closeProject(project);
                break;
              case 'view':
                _showProjectDetails(project);
                break;
              case 'delete':
                _showDeleteProjectDialog(project);
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildInvestments() {
    return Consumer<InvestmentProvider>(
      builder: (context, provider, child) {
        final investments = provider.investments;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Investments Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              
              if (investments.isEmpty)
                const Center(
                  child: Text(
                    'No investments found',
                    style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: investments.length,
                  itemBuilder: (context, index) {
                    final investment = investments[index];
                    return _buildInvestmentCard(investment);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInvestmentCard(Investment investment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(
            Icons.trending_up,
            color: AppColors.primary,
          ),
        ),
        title: Text('Investment \$${investment.amount.toStringAsFixed(0)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project: ${investment.projectId}'),
            Text('Status: ${investment.status}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'view') {
              _showInvestmentDetails(investment);
            } else if (value == 'edit') {
              _showEditInvestmentDialog(investment);
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'User Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAssignRoleDialog(),
                icon: const Icon(Icons.person_add),
                label: const Text('Assign Role'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          const Text(
            'User management features will be implemented here',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          const Text(
            'Settings configuration will be implemented here',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // Dialog methods (to be implemented)
  void _showCreateCooperativeDialog() {
    // TODO: Implement cooperative creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Cooperative dialog - To be implemented')),
    );
  }

  void _showEditCooperativeDialog(Cooperative cooperative) {
    // TODO: Implement cooperative editing dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Cooperative dialog - To be implemented')),
    );
  }

  void _showDeleteCooperativeDialog(Cooperative cooperative) {
    // TODO: Implement cooperative deletion dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete Cooperative dialog - To be implemented')),
    );
  }

  void _showCreateBusinessDialog() {
    // TODO: Implement business creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Business dialog - To be implemented')),
    );
  }

  void _showEditBusinessDialog(Business business) {
    // TODO: Implement business editing dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Business dialog - To be implemented')),
    );
  }

  void _showDeleteBusinessDialog(Business business) {
    // TODO: Implement business deletion dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete Business dialog - To be implemented')),
    );
  }

  void _approveBusiness(Business business) {
    // TODO: Implement business approval
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Business approval - To be implemented')),
    );
  }

  void _showCreateProjectDialog() {
    // TODO: Implement project creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Project dialog - To be implemented')),
    );
  }

  void _showEditProjectDialog(Project project) {
    // TODO: Implement project editing dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Project dialog - To be implemented')),
    );
  }

  void _showDeleteProjectDialog(Project project) {
    // TODO: Implement project deletion dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete Project dialog - To be implemented')),
    );
  }

  void _showInvestmentDetails(Investment investment) {
    // TODO: Implement investment details view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Investment details - To be implemented')),
    );
  }

  void _showEditInvestmentDialog(Investment investment) {
    // TODO: Implement investment editing dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Investment dialog - To be implemented')),
    );
  }

  void _showAssignRoleDialog() {
    // TODO: Implement role assignment dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assign Role dialog - To be implemented')),
    );
  }

  void _showReportsDialog() {
    // TODO: Implement reports dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reports dialog - To be implemented')),
    );
  }

  // Project approval methods
  Future<void> _approveProject(Project project) async {
    try {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      final success = await projectProvider.approveProject(project.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${project.title}" approved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error approving project: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRejectProjectDialog(Project project) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Project: ${project.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _rejectProject(project, reasonController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  Future<void> _rejectProject(Project project, String reason) async {
    try {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      final success = await projectProvider.rejectProject(project.id, reason: reason);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${project.title}" rejected.'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error rejecting project: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startInvestment(Project project) async {
    try {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      final success = await projectProvider.startInvestment(project.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Investment process started for "${project.title}"!'),
            backgroundColor: Colors.blue,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting investment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _closeProject(Project project) async {
    try {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      final success = await projectProvider.closeProject(project.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Funding closed for "${project.title}"!'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error closing project: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showProjectDetails(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Description: ${project.description}'),
              const SizedBox(height: 8),
              Text('Business ID: ${project.businessId}'),
              const SizedBox(height: 8),
              Text('Funding Goal: \$${project.fundingGoal.toStringAsFixed(0)}'),
              if (project.minimumFunding != null)
                Text('Minimum Funding: \$${project.minimumFunding!.toStringAsFixed(0)}'),
              Text('Current Funding: \$${project.currentFunding.toStringAsFixed(0)}'),
              Text('Progress: ${project.fundingProgress.toStringAsFixed(1)}%'),
              const SizedBox(height: 8),
              Text('Project Type: ${project.projectType}'),
              Text('Status: ${project.status.toUpperCase()}'),
              if (project.fundingDeadline != null)
                Text('Deadline: ${project.fundingDeadline!.toLocal().toString()}'),
              const SizedBox(height: 8),
              Text('Created: ${project.createdAt.toLocal().toString()}'),
              Text('Updated: ${project.updatedAt.toLocal().toString()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
