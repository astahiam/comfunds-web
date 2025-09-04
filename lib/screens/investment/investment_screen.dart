import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/investment_provider.dart';
import '../../providers/project_provider.dart';
import '../../utils/constants.dart';
import '../../utils/role_constants.dart';
import '../../models/project.dart';
import '../../models/investment.dart';

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({super.key});

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  List<dynamic> _availableProjects = [];
  List<Investment> _myInvestments = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      
      if (user != null) {
        final investmentProvider = Provider.of<InvestmentProvider>(context, listen: false);
        
        // Load available projects for investment
        _availableProjects = await investmentProvider.getAvailableProjectsForInvestment(
          cooperativeId: user.cooperativeId,
        );
        
        // Load user's investments
        await investmentProvider.fetchInvestmentsByMember(
          user.id,
          cooperativeId: user.cooperativeId,
        );
        _myInvestments = investmentProvider.investments;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
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
                      icon: Icon(Icons.trending_up),
                      label: Text('Available Projects'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.portfolio),
                      label: Text('My Investments'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.history),
                      label: Text('Investment History'),
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
        return _buildAvailableProjects();
      case 1:
        return _buildMyInvestments();
      case 2:
        return _buildInvestmentHistory();
      default:
        return _buildAvailableProjects();
    }
  }

  Widget _buildAvailableProjects() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Projects for Investment',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          if (_availableProjects.isEmpty)
            const Center(
              child: Text(
                'No projects available for investment at the moment.',
                style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _availableProjects.length,
              itemBuilder: (context, index) {
                final projectData = _availableProjects[index];
                return _buildProjectCard(projectData);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> projectData) {
    final project = Project.fromJson(projectData);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(project.status.toUpperCase()),
                  backgroundColor: _getStatusColor(project.status),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              project.description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Project details
            Row(
              children: [
                Expanded(
                  child: _buildProjectDetail(
                    'Funding Goal',
                    '\$${project.fundingGoal.toStringAsFixed(0)}',
                    Icons.account_balance_wallet,
                  ),
                ),
                Expanded(
                  child: _buildProjectDetail(
                    'Current Funding',
                    '\$${project.currentFunding.toStringAsFixed(0)}',
                    Icons.trending_up,
                  ),
                ),
                Expanded(
                  child: _buildProjectDetail(
                    'Progress',
                    '${project.fundingProgress.toStringAsFixed(1)}%',
                    Icons.pie_chart,
                  ),
                ),
              ],
            ),
            
            if (project.fundingDeadline != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.schedule, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Deadline: ${project.fundingDeadline!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Investment action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showInvestmentDialog(project),
                icon: const Icon(Icons.investment),
                label: const Text('Invest Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMyInvestments() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Investment Portfolio',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          if (_myInvestments.isEmpty)
            const Center(
              child: Text(
                'You haven\'t made any investments yet.',
                style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _myInvestments.length,
              itemBuilder: (context, index) {
                final investment = _myInvestments[index];
                return _buildInvestmentCard(investment);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInvestmentCard(Investment investment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(
            Icons.investment,
            color: AppColors.primary,
          ),
        ),
        title: Text('Investment #${investment.id.substring(0, 8)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: \$${investment.amount.toStringAsFixed(0)}'),
            Text('Status: ${investment.status.toUpperCase()}'),
            Text('Date: ${investment.createdAt.toLocal().toString().split(' ')[0]}'),
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
            if (investment.isPending)
              const PopupMenuItem(
                value: 'withdraw',
                child: Row(
                  children: [
                    Icon(Icons.undo, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Withdraw'),
                  ],
                ),
              ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'view':
                _showInvestmentDetails(investment);
                break;
              case 'withdraw':
                _showWithdrawInvestmentDialog(investment);
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildInvestmentHistory() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Investment History',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          // This would show historical investment data
          const Center(
            child: Text(
              'Investment history will be displayed here.',
              style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
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
      case 'closed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showInvestmentDialog(Project project) {
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invest in ${project.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available for investment: \$${(project.fundingGoal - project.currentFunding).toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Investment Amount (\$)',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
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
              await _makeInvestment(project, amountController.text);
            },
            child: const Text('Invest'),
          ),
        ],
      ),
    );
  }

  Future<void> _makeInvestment(Project project, String amountText) async {
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount > (project.fundingGoal - project.currentFunding)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Investment amount exceeds available funding'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final investmentProvider = Provider.of<InvestmentProvider>(context, listen: false);
      final success = await investmentProvider.createInvestment(
        projectId: project.id,
        investorId: user.id,
        amount: amount,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully invested \$${amount.toStringAsFixed(0)} in ${project.title}'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error making investment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showInvestmentDetails(Investment investment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Investment Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Investment ID: ${investment.id}'),
            const SizedBox(height: 8),
            Text('Project ID: ${investment.projectId}'),
            Text('Amount: \$${investment.amount.toStringAsFixed(0)}'),
            Text('Status: ${investment.status.toUpperCase()}'),
            Text('Profit Sharing: ${investment.profitSharingPercentage.toStringAsFixed(1)}%'),
            if (investment.investmentDate != null)
              Text('Investment Date: ${investment.investmentDate!.toLocal().toString()}'),
            const SizedBox(height: 8),
            Text('Created: ${investment.createdAt.toLocal().toString()}'),
            Text('Updated: ${investment.updatedAt.toLocal().toString()}'),
          ],
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

  void _showWithdrawInvestmentDialog(Investment investment) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Investment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to withdraw your investment of \$${investment.amount.toStringAsFixed(0)}?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for withdrawal (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
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
              await _withdrawInvestment(investment, reasonController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  Future<void> _withdrawInvestment(Investment investment, String reason) async {
    try {
      final investmentProvider = Provider.of<InvestmentProvider>(context, listen: false);
      final success = await investmentProvider.withdrawInvestment(
        investment.id,
        reason: reason.isEmpty ? null : reason,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Investment withdrawn successfully'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error withdrawing investment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
