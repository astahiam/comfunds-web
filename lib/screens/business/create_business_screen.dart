import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/cooperative_provider.dart';
import '../../utils/constants.dart';
import '../../utils/role_constants.dart';
import '../../models/cooperative.dart';
import '../../models/business.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _industryController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _annualRevenueController = TextEditingController();
  final _employeeCountController = TextEditingController();

  String? _selectedCooperativeId;
  String? _selectedBusinessType;
  String? _selectedIndustry;
  bool _isLoading = false;
  List<Cooperative> _userCooperatives = [];

  final List<String> _businessTypes = [
    'umkm',
    'startup',
    'corporation',
    'partnership',
    'sole_proprietorship',
  ];

  final List<String> _industries = [
    'retail',
    'food_beverage',
    'manufacturing',
    'technology',
    'healthcare',
    'education',
    'tourism',
    'agriculture',
    'fishery',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserCooperatives();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _businessTypeController.dispose();
    _industryController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _registrationNumberController.dispose();
    _taxIdController.dispose();
    _bankAccountController.dispose();
    _bankNameController.dispose();
    _annualRevenueController.dispose();
    _employeeCountController.dispose();
    super.dispose();
  }

  Future<void> _loadUserCooperatives() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      
      if (user != null && user.cooperativeId != null) {
        // User is already a member of a cooperative
        final cooperativeProvider = Provider.of<CooperativeProvider>(context, listen: false);
        await cooperativeProvider.fetchCooperatives();
        
        final cooperatives = cooperativeProvider.cooperatives;
        final userCooperative = cooperatives.firstWhere(
          (coop) => coop.id == user.cooperativeId,
          orElse: () => Cooperative.empty(),
        );
        
        if (userCooperative.id.isNotEmpty) {
          setState(() {
            _userCooperatives = [userCooperative];
            _selectedCooperativeId = userCooperative.id;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading cooperatives: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createBusiness() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCooperativeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a cooperative'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      await businessProvider.createBusiness(
        name: _nameController.text,
        businessType: _selectedBusinessType ?? '',
        description: _descriptionController.text,
        ownerId: user.id,
        cooperativeId: _selectedCooperativeId!,
        registrationDocuments: {
          'industry': _selectedIndustry ?? '',
          'address': _addressController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'website': _websiteController.text,
          'registration_number': _registrationNumberController.text,
          'tax_id': _taxIdController.text,
          'bank_account': _bankAccountController.text,
          'bank_name': _bankNameController.text,
          'annual_revenue': double.tryParse(_annualRevenueController.text) ?? 0.0,
          'employee_count': int.tryParse(_employeeCountController.text) ?? 0,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business created successfully! Awaiting approval.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating business: $e'),
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
        title: const Text('Create UMKM Business'),
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
                'Create Your UMKM Business',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill in the details below to create your business. Your business will be reviewed by cooperative administrators.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Cooperative Selection
              if (_userCooperatives.isNotEmpty) ...[
                const Text(
                  'Cooperative',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCooperativeId,
                  decoration: const InputDecoration(
                    labelText: 'Select Cooperative *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  items: _userCooperatives.map((cooperative) {
                    return DropdownMenuItem(
                      value: cooperative.id,
                      child: Text(cooperative.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCooperativeId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a cooperative';
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
                              'No Cooperative Membership',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You need to be a member of a cooperative to create a business. Please join a cooperative first.',
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/cooperatives');
                              },
                              child: const Text('Join Cooperative'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Business Information
              const Text(
                'Business Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Business Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Business Name *',
                  hintText: 'Enter your business name',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Business name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Business Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Business Description *',
                  hintText: 'Describe your business activities',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Business description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Business Type
              DropdownButtonFormField<String>(
                value: _selectedBusinessType,
                decoration: const InputDecoration(
                  labelText: 'Business Type *',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: _businessTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.replaceAll('_', ' ').toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBusinessType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a business type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Industry
              DropdownButtonFormField<String>(
                value: _selectedIndustry,
                decoration: const InputDecoration(
                  labelText: 'Industry *',
                  prefixIcon: Icon(Icons.factory),
                  border: OutlineInputBorder(),
                ),
                items: _industries.map((industry) {
                  return DropdownMenuItem(
                    value: industry,
                    child: Text(industry.replaceAll('_', ' ').toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedIndustry = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an industry';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Business Address *',
                  hintText: 'Enter your business address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Business address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contact Information
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number *',
                        hintText: 'Enter phone number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email *',
                        hintText: 'Enter business email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Website
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website (Optional)',
                  hintText: 'Enter business website URL',
                  prefixIcon: Icon(Icons.language),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),

              // Legal Information
              const Text(
                'Legal Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _registrationNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Registration Number *',
                        hintText: 'Business registration number',
                        prefixIcon: Icon(Icons.assignment),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Registration number is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _taxIdController,
                      decoration: const InputDecoration(
                        labelText: 'Tax ID *',
                        hintText: 'Business tax identification',
                        prefixIcon: Icon(Icons.receipt),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tax ID is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Banking Information
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _bankAccountController,
                      decoration: const InputDecoration(
                        labelText: 'Bank Account *',
                        hintText: 'Bank account number',
                        prefixIcon: Icon(Icons.account_balance),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bank account is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _bankNameController,
                      decoration: const InputDecoration(
                        labelText: 'Bank Name *',
                        hintText: 'Name of the bank',
                        prefixIcon: Icon(Icons.account_balance_wallet),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bank name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Financial Information
              const Text(
                'Financial Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _annualRevenueController,
                      decoration: const InputDecoration(
                        labelText: 'Annual Revenue (IDR)',
                        hintText: 'Enter annual revenue',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _employeeCountController,
                      decoration: const InputDecoration(
                        labelText: 'Number of Employees',
                        hintText: 'Enter employee count',
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _userCooperatives.isEmpty || _isLoading ? null : _createBusiness,
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
                          'Create Business',
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
                            'Business Creation Process',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1. Submit your business application\n'
                            '2. Cooperative administrators will review your application\n'
                            '3. Once approved, you can create projects for funding\n'
                            '4. Investors can then invest in your projects',
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
