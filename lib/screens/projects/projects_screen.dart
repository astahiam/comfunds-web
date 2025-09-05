import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/business_provider.dart';
import '../../models/project.dart';
import '../../models/business.dart';
import '../../utils/constants.dart';
import '../../utils/role_constants.dart';
import 'create_project_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      
      if (user != null) {
        final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
        
        // Load all projects in the user's cooperative
        await projectProvider.fetchProjects(cooperativeId: user.cooperativeId);
        
        // If user is a business owner, load their businesses
        if (user.isBusinessOwner) {
          await Provider.of<BusinessProvider>(context, listen: false)
              .fetchBusinessesByOwner(user.id);
        }
      }
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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Projects'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(
                  icon: Icon(Icons.public),
                  text: 'All Projects',
                ),
                Tab(
                  icon: Icon(Icons.trending_up),
                  text: 'Active Funding',
                ),
                Tab(
                  icon: Icon(Icons.business_center),
                  text: 'My Projects',
                ),
              ],
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAllProjectsTab(user),
                    _buildActiveFundingTab(user),
                    _buildMyProjectsTab(user),
                  ],
                ),
          floatingActionButton: user.isBusinessOwner
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateProjectScreen(),
                      ),
                    ).then((_) => _loadData());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Project'),
                  backgroundColor: AppColors.primary,
                )
              : null,
        );
      },
    );
  }

  Widget _buildAllProjectsTab(user) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        final projects = projectProvider.projects;

        if (projects.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Projects Available',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'There are no projects in your cooperative yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return _buildProjectCard(project);
            },
          ),
        );
      },
    );
  }

  Widget _buildActiveFundingTab(user) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        final activeProjects = projectProvider.projects
            .where((project) => project.isActive && !project.isFullyFunded)
            .toList();

        if (activeProjects.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Active Funding Projects',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'There are no projects currently seeking funding.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activeProjects.length,
            itemBuilder: (context, index) {
              final project = activeProjects[index];
              return _buildProjectCard(project, showInvestButton: true);
            },
          ),
        );
      },
    );
  }

  Widget _buildMyProjectsTab(user) {
    return Consumer2<ProjectProvider, BusinessProvider>(
      builder: (context, projectProvider, businessProvider, child) {
        if (!user.isBusinessOwner) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business_center_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Not a Business Owner',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'You need to create and get approval for a business to manage projects.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final userBusinesses = businessProvider.businesses;
        final businessIds = userBusinesses.map((b) => b.id).toSet();
        final myProjects = projectProvider.projects
            .where((project) => businessIds.contains(project.businessId))
            .toList();

        if (myProjects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_business, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No Projects Yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create your first project to start raising funds.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateProjectScreen(),
                      ),
                    ).then((_) => _loadData());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myProjects.length,
            itemBuilder: (context, index) {
              final project = myProjects[index];
              return _buildProjectCard(project, showManageButton: true);
            },
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(Project project, {bool showInvestButton = false, bool showManageButton = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(project.status.toUpperCase()),
                  backgroundColor: _getStatusColor(project.status),
                  labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Chip(
                  label: Text(project.projectType.toUpperCase()),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  labelStyle: const TextStyle(fontSize: 10),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            Text(
              project.description,
              style: const TextStyle(color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            
            // Funding Progress
            if (project.isActive || project.isFunded) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'IDR ${_formatCurrency(project.currentFunding)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Goal: IDR ${_formatCurrency(project.fundingGoal)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: project.fundingProgress / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  project.fundingProgress >= 100 ? Colors.green : AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${project.fundingProgress.toStringAsFixed(1)}% funded'),
                  if (project.fundingDeadline != null)
                    Text(
                      'Deadline: ${_formatDate(project.fundingDeadline!)}',
                      style: TextStyle(
                        color: project.isFundingExpired ? Colors.red : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            
            // Investment Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Investor Share: ${project.investorSharePercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showProjectDetails(project),
                    child: const Text('View Details'),
                  ),
                ),
                
                if (showInvestButton) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: project.isFullyFunded || project.isFundingExpired
                          ? null
                          : () => _navigateToInvestment(project),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Invest'),
                    ),
                  ),
                ],
                
                if (showManageButton) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showProjectManagement(project),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Manage'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
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
              Text('Status: ${project.status.toUpperCase()}'),
              const SizedBox(height: 8),
              Text('Type: ${project.projectType.toUpperCase()}'),
              const SizedBox(height: 8),
              Text('Description: ${project.description}'),
              const SizedBox(height: 16),
              Text('Funding Goal: IDR ${_formatCurrency(project.fundingGoal)}'),
              Text('Current Funding: IDR ${_formatCurrency(project.currentFunding)}'),
              Text('Progress: ${project.fundingProgress.toStringAsFixed(1)}%'),
              const SizedBox(height: 16),
              Text('Investor Share: ${project.investorSharePercentage.toStringAsFixed(0)}%'),
              Text('Business Share: ${project.businessSharePercentage.toStringAsFixed(0)}%'),
              if (project.fundingDeadline != null) ...[
                const SizedBox(height: 8),
                Text('Deadline: ${_formatDate(project.fundingDeadline!)}'),
              ],
              const SizedBox(height: 8),
              Text('Created: ${_formatDate(project.createdAt)}'),
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

  void _navigateToInvestment(Project project) {
    Navigator.of(context).pushNamed('/investment');
  }

  void _showProjectManagement(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage: ${project.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (project.isDraft) ...[
              ListTile(
                leading: const Icon(Icons.send, color: Colors.blue),
                title: const Text('Submit for Approval'),
                subtitle: const Text('Submit your project for cooperative review'),
                onTap: () {
                  Navigator.of(context).pop();
                  _submitProject(project);
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Edit Project'),
              subtitle: const Text('Modify project details'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Navigate to edit project screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.green),
              title: const Text('View Analytics'),
              subtitle: const Text('See project performance metrics'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Navigate to project analytics
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitProject(Project project) async {
    try {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      final success = await projectProvider.submitProject(project.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project submitted for approval successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting project: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'approved':
        return Colors.blue;
      case 'submitted':
        return Colors.orange;
      case 'draft':
        return Colors.grey;
      case 'funded':
        return Colors.purple;
      case 'closed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
