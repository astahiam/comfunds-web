import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/project_provider.dart';
import '../../utils/constants.dart';
import '../../utils/role_constants.dart';
import '../../models/business.dart';
import '../../models/project.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _fundingGoalController = TextEditingController();
  final _minimumFundingController = TextEditingController();
  final _investorShareController = TextEditingController();
  final _businessShareController = TextEditingController();

  String? _selectedBusinessId;
  String? _selectedProjectType;
  DateTime? _fundingDeadline;
  bool _isLoading = false;
  List<Business> _userBusinesses = [];

  final List<String> _projectTypes = [
    'startup',
    'expansion',
    'equipment',
    'inventory',
    'marketing',
    'research',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserBusinesses();
    // Set default profit sharing ratios
    _investorShareController.text = '70';
    _businessShareController.text = '30';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _fundingGoalController.dispose();
    _minimumFundingController.dispose();
    _investorShareController.dispose();
    _businessShareController.dispose();
    super.dispose();
  }

  Future<void> _loadUserBusinesses() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      
      if (user != null) {
        final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
        await businessProvider.fetchBusinessesByOwner(user.id);
        
        // Filter only approved businesses
        final approvedBusinesses = businessProvider.businesses
            .where((business) => business.isApproved)
            .toList();
        
        setState(() {
          _userBusinesses = approvedBusinesses;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading businesses: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectFundingDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select funding deadline',
    );
    
    if (picked != null && picked != _fundingDeadline) {
      setState(() {
        _fundingDeadline = picked;
      });
    }
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBusinessId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a business'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      
      final investorShare = double.tryParse(_investorShareController.text) ?? 70.0;
      final businessShare = double.tryParse(_businessShareController.text) ?? 30.0;
      
      if (investorShare + businessShare != 100.0) {
        throw Exception('Profit sharing percentages must total 100%');
      }

      final success = await projectProvider.createProject(
        title: _titleController.text,
        description: _descriptionController.text,
        businessId: _selectedBusinessId!,
        fundingGoal: double.parse(_fundingGoalController.text),
        minimumFunding: _minimumFundingController.text.isNotEmpty 
            ? double.parse(_minimumFundingController.text) 
            : null,
        fundingDeadline: _fundingDeadline,
        profitSharingRatio: {
          'investor': investorShare,
          'business': businessShare,
        },
        projectType: _selectedProjectType ?? 'startup',
        milestones: [], // Can be added later
        documents: {}, // Can be added later
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project created successfully! You can now submit it for approval.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating project: $e'),
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

  void _updateBusinessShare() {
    final investorShare = double.tryParse(_investorShareController.text) ?? 0.0;
    final businessShare = 100.0 - investorShare;
    _businessShareController.text = businessShare.toStringAsFixed(1);
  }

  void _updateInvestorShare() {
    final businessShare = double.tryParse(_businessShareController.text) ?? 0.0;
    final investorShare = 100.0 - businessShare;
    _investorShareController.text = investorShare.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Investment Project',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create a project to raise funds from cooperative members for your business.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Business Selection
              if (_userBusinesses.isNotEmpty) ...[
                const Text(
                  'Business',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedBusinessId,
                  decoration: const InputDecoration(
                    labelText: 'Select Business *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  items: _userBusinesses.map((business) {
                    return DropdownMenuItem(
                      value: business.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(business.name),
                          Text(
                            business.businessType.replaceAll('_', ' ').toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBusinessId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a business';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'No Approved Business',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You need to have an approved business to create a project. Please create and get approval for a business first.',
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/create-business');
                              },
                              child: const Text('Create Business'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Project Information
              const Text(
                'Project Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Project Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Project Title *',
                  hintText: 'Enter a descriptive project title',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Project title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Project Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Project Description *',
                  hintText: 'Describe your project goals, timeline, and expected outcomes',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Project description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Project Type
              DropdownButtonFormField<String>(
                value: _selectedProjectType,
                decoration: const InputDecoration(
                  labelText: 'Project Type *',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: _projectTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.replaceAll('_', ' ').toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProjectType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a project type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Funding Information
              const Text(
                'Funding Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Funding Goal
              TextFormField(
                controller: _fundingGoalController,
                decoration: const InputDecoration(
                  labelText: 'Funding Goal (IDR) *',
                  hintText: 'Enter total funding needed',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Funding goal is required';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Minimum Funding
              TextFormField(
                controller: _minimumFundingController,
                decoration: const InputDecoration(
                  labelText: 'Minimum Funding (IDR)',
                  hintText: 'Minimum amount needed to start the project',
                  prefixIcon: Icon(Icons.money_off),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final minAmount = double.tryParse(value);
                    final goalAmount = double.tryParse(_fundingGoalController.text);
                    if (minAmount == null || minAmount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    if (goalAmount != null && minAmount > goalAmount) {
                      return 'Minimum funding cannot exceed funding goal';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Funding Deadline
              InkWell(
                onTap: _selectFundingDeadline,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Funding Deadline',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _fundingDeadline != null
                        ? '${_fundingDeadline!.day}/${_fundingDeadline!.month}/${_fundingDeadline!.year}'
                        : 'Select deadline (optional)',
                    style: TextStyle(
                      color: _fundingDeadline != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Profit Sharing
              const Text(
                'Profit Sharing',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Define how profits will be shared between investors and your business',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _investorShareController,
                      decoration: const InputDecoration(
                        labelText: 'Investor Share (%)',
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _updateBusinessShare(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final share = double.tryParse(value);
                        if (share == null || share < 0 || share > 100) {
                          return 'Enter 0-100';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _businessShareController,
                      decoration: const InputDecoration(
                        labelText: 'Business Share (%)',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _updateInvestorShare(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final share = double.tryParse(value);
                        if (share == null || share < 0 || share > 100) {
                          return 'Enter 0-100';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _userBusinesses.isEmpty || _isLoading ? null : _createProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                          'Create Project',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Information Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Project Creation Process',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1. Create your project with detailed information\n'
                            '2. Submit your project for cooperative admin approval\n'
                            '3. Once approved, cooperative members can invest\n'
                            '4. Track funding progress and manage your project',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
