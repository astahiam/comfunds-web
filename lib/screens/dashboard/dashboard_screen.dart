import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/investment_provider.dart';
import '../../providers/cooperative_provider.dart';
import '../../providers/business_provider.dart';
import '../../models/user.dart';
import '../../models/project.dart';
import '../../models/investment.dart';
import '../../models/business.dart';
import '../../models/cooperative.dart';
import '../../utils/constants.dart';
import '../../utils/role_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      // Load data based on user roles
      if (user.hasRole(UserRoles.investor)) {
        await Provider.of<InvestmentProvider>(context, listen: false)
            .fetchPortfolio(user.id);
      }
      
      if (user.hasRole(UserRoles.businessOwner)) {
        await Provider.of<BusinessProvider>(context, listen: false)
            .fetchBusinessesByOwner(user.id);
      }
      
      if (user.hasRole(UserRoles.member)) {
        await Provider.of<ProjectProvider>(context, listen: false)
            .fetchProjects(cooperativeId: user.cooperativeId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('ComFunds Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // TODO: Show notifications
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'profile') {
                    // TODO: Navigate to profile
                  } else if (value == 'logout') {
                    authProvider.logout();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Text('Profile'),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
          body: Row(
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
                destinations: _buildNavigationDestinations(user),
                minWidth: 200,
              ),
              // Main Content
              Expanded(
                child: _buildMainContent(user),
              ),
            ],
          ),
        );
      },
    );
  }

  List<NavigationRailDestination> _buildNavigationDestinations(User user) {
    final destinations = <NavigationRailDestination>[
      const NavigationRailDestination(
        icon: Icon(Icons.dashboard),
        label: Text('Overview'),
      ),
    ];

    if (user.hasRole('investor')) {
      destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.account_balance_wallet),
        label: Text('Portfolio'),
      ));
    }

    if (user.hasRole('business_owner')) {
      destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.business),
        label: Text('My Businesses'),
      ));
    }

    if (user.hasRole('member')) {
      destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.work),
        label: Text('Projects'),
      ));
      
      // Add investment option for cooperative members
      destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.trending_up),
        label: Text('Investments'),
      ));
    }

    // Add business creation option for cooperative members
    if (user.hasRole('member') && user.cooperativeId != null) {
      destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.add_business),
        label: Text('Create Business'),
      ));
    }

    destinations.addAll([
      const NavigationRailDestination(
        icon: Icon(Icons.people),
        label: Text('Cooperatives'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.analytics),
        label: Text('Analytics'),
      ),
    ]);

    return destinations;
  }

  Widget _buildMainContent(User user) {
    switch (_selectedIndex) {
      case 0:
        return _buildOverviewTab(user);
      case 1:
        if (user.hasRole('investor')) {
          return _buildPortfolioTab();
        } else if (user.hasRole('business_owner')) {
          return _buildBusinessesTab();
        } else {
          return _buildProjectsTab();
        }
      case 2:
        if (user.hasRole('business_owner')) {
          return _buildBusinessesTab();
        } else if (user.hasRole('member')) {
          return _buildProjectsTab();
        } else {
          return _buildCooperativesTab();
        }
      case 3:
        if (user.hasRole('member')) {
          return _buildProjectsTab();
        } else {
          return _buildCooperativesTab();
        }
      case 4:
        if (user.hasRole('member')) {
          return _buildInvestmentsTab();
        } else {
          return _buildCooperativesTab();
        }
      case 5:
        if (user.hasRole('member') && user.cooperativeId != null) {
          return _buildCreateBusinessTab();
        } else {
          return _buildCooperativesTab();
        }
      case 6:
        return _buildCooperativesTab();
      case 7:
        return _buildAnalyticsTab();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  Widget _buildOverviewTab(User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, ${user.name}!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // User Roles Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Roles',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: user.roles.map((role) => Chip(
                      label: Text(role.replaceAll('_', ' ').toUpperCase()),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Stats
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Investments', '0', Icons.account_balance_wallet)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Active Projects', '0', Icons.work)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Total Returns', '\$0', Icons.trending_up)),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text('No recent activity'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return Consumer<InvestmentProvider>(
      builder: (context, investmentProvider, child) {
        if (investmentProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final portfolio = investmentProvider.portfolio;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Investment Portfolio',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              
              if (portfolio.isEmpty)
                const Center(
                  child: Text('No investments yet'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: portfolio.length,
                  itemBuilder: (context, index) {
                    final investment = portfolio[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text('Investment #${investment.id}'),
                        subtitle: Text('\$${investment.amount.toStringAsFixed(2)}'),
                        trailing: Chip(
                          label: Text(investment.status),
                          backgroundColor: investment.isActive 
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBusinessesTab() {
    return Consumer<BusinessProvider>(
      builder: (context, businessProvider, child) {
        if (businessProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final businesses = businessProvider.businesses;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Businesses',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to create business
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Business'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (businesses.isEmpty)
                const Center(
                  child: Text('No businesses yet'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: businesses.length,
                  itemBuilder: (context, index) {
                    final business = businesses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(business.name),
                        subtitle: Text(business.businessType),
                        trailing: Chip(
                          label: Text(business.approvalStatus),
                          backgroundColor: business.isApproved 
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectsTab() {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        if (projectProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final projects = projectProvider.projects;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Projects',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to create project
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Project'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (projects.isEmpty)
                const Center(
                  child: Text('No projects available'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(project.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(project.description),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: project.fundingProgress / 100,
                              backgroundColor: Colors.grey[300],
                            ),
                            Text('${project.fundingProgress.toStringAsFixed(1)}% funded'),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(project.status),
                          backgroundColor: _getStatusColor(project.status),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green.withOpacity(0.1);
      case 'approved':
        return Colors.blue.withOpacity(0.1);
      case 'pending':
        return Colors.orange.withOpacity(0.1);
      case 'draft':
        return Colors.grey.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Widget _buildCooperativesTab() {
    return Consumer<CooperativeProvider>(
      builder: (context, cooperativeProvider, child) {
        if (cooperativeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final cooperatives = cooperativeProvider.cooperatives;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cooperatives',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              
              if (cooperatives.isEmpty)
                const Center(
                  child: Text('No cooperatives available'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cooperatives.length,
                  itemBuilder: (context, index) {
                    final cooperative = cooperatives[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(cooperative.name),
                        subtitle: Text(cooperative.address),
                        trailing: cooperative.isActive 
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return const Center(
      child: Text('Analytics coming soon...'),
    );
  }

  Widget _buildInvestmentsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.trending_up, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Investment Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'View and manage your investments in cooperative projects',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/investment'),
            icon: Icon(Icons.open_in_new),
            label: Text('Go to Investment Dashboard'),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateBusinessTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_business, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Create New Business',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Start a new UMKM business within your cooperative',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/create-business'),
            icon: Icon(Icons.add),
            label: Text('Create Business'),
          ),
        ],
      ),
    );
  }
}
