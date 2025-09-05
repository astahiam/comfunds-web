import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/investment_provider.dart';
import '../../models/project.dart';
import '../../models/investment.dart';
import '../../utils/constants.dart';

class InvestmentDetailScreen extends StatefulWidget {
  final Project project;

  const InvestmentDetailScreen({
    super.key,
    required this.project,
  });

  @override
  State<InvestmentDetailScreen> createState() => _InvestmentDetailScreenState();
}

class _InvestmentDetailScreenState extends State<InvestmentDetailScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;
  List<Investment> _projectInvestments = [];

  @override
  void initState() {
    super.initState();
    _loadProjectInvestments();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadProjectInvestments() async {
    try {
      final investmentProvider = Provider.of<InvestmentProvider>(context, listen: false);
      _projectInvestments = await investmentProvider.getProjectInvestments(widget.project.id);
      if (mounted) setState(() {});
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> _makeInvestment() async {
    if (_amountController.text.isEmpty) {
      _showSnackBar('Please enter an investment amount', Colors.red);
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showSnackBar('Please enter a valid amount', Colors.red);
      return;
    }

    final remainingFunding = widget.project.fundingGoal - widget.project.currentFunding;
    if (amount > remainingFunding) {
      _showSnackBar('Investment amount exceeds remaining funding needed', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final investmentProvider = Provider.of<InvestmentProvider>(context, listen: false);
      final success = await investmentProvider.createInvestment(
        projectId: widget.project.id,
        investorId: user.id,
        amount: amount,
        profitSharingPercentage: widget.project.investorSharePercentage,
      );

      if (success && mounted) {
        _showSnackBar(
          'Successfully invested IDR ${_formatCurrency(amount)} in ${widget.project.title}',
          Colors.green,
        );
        _amountController.clear();
        await _loadProjectInvestments();
        Navigator.of(context).pop(); // Return to previous screen
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error making investment: $e', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final remainingFunding = widget.project.fundingGoal - widget.project.currentFunding;
    final daysRemaining = widget.project.fundingDeadline != null
        ? widget.project.fundingDeadline!.difference(DateTime.now()).inDays
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.project.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(widget.project.projectType.toUpperCase()),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.project.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Funding Progress
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Funding Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    LinearProgressIndicator(
                      value: widget.project.fundingProgress / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.project.fundingProgress >= 100 ? Colors.green : AppColors.primary,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IDR ${_formatCurrency(widget.project.currentFunding)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Text('Raised'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'IDR ${_formatCurrency(widget.project.fundingGoal)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('Goal'),
                          ],
                        ),
                      ],
                    ),

                    if (widget.project.minimumFunding != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.project.hasMinimumFunding 
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              widget.project.hasMinimumFunding 
                                  ? Icons.check_circle 
                                  : Icons.access_time,
                              color: widget.project.hasMinimumFunding 
                                  ? Colors.green 
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Minimum funding: IDR ${_formatCurrency(widget.project.minimumFunding!)} ${widget.project.hasMinimumFunding ? "(Reached)" : "(Needed)"}',
                              style: TextStyle(
                                color: widget.project.hasMinimumFunding 
                                    ? Colors.green 
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (daysRemaining != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: daysRemaining <= 7 
                              ? Colors.red.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: daysRemaining <= 7 ? Colors.red : Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              daysRemaining > 0 
                                  ? '$daysRemaining days remaining'
                                  : 'Funding deadline passed',
                              style: TextStyle(
                                color: daysRemaining <= 7 ? Colors.red : Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Investment Terms
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Investment Terms',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildTermCard(
                            'Investor Share',
                            '${widget.project.investorSharePercentage.toStringAsFixed(0)}%',
                            Icons.people,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTermCard(
                            'Business Share',
                            '${widget.project.businessSharePercentage.toStringAsFixed(0)}%',
                            Icons.business,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Investment Form
            if (!widget.project.isFullyFunded && !widget.project.isFundingExpired) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Make Investment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: 'Investment Amount (IDR)',
                          hintText: 'Enter amount to invest',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: const OutlineInputBorder(),
                          helperText: 'Available: IDR ${_formatCurrency(remainingFunding)}',
                        ),
                        keyboardType: TextInputType.number,
                        enabled: !_isLoading,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _makeInvestment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Invest Now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        widget.project.isFullyFunded 
                            ? Icons.check_circle 
                            : Icons.access_time_filled,
                        size: 48,
                        color: widget.project.isFullyFunded 
                            ? Colors.green 
                            : Colors.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.project.isFullyFunded 
                            ? 'Project Fully Funded'
                            : 'Funding Period Ended',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.project.isFullyFunded 
                              ? Colors.green 
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.project.isFullyFunded 
                            ? 'This project has reached its funding goal.'
                            : 'The funding deadline for this project has passed.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Recent Investments
            if (_projectInvestments.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Investments (${_projectInvestments.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _projectInvestments.take(5).length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final investment = _projectInvestments[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: const Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text('IDR ${_formatCurrency(investment.amount)}'),
                            subtitle: Text(
                              investment.investmentDate != null
                                  ? _formatDate(investment.investmentDate!)
                                  : _formatDate(investment.createdAt),
                            ),
                            trailing: Chip(
                              label: Text(investment.status.toUpperCase()),
                              backgroundColor: _getInvestmentStatusColor(investment.status),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTermCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getInvestmentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'refunded':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
