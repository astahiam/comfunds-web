import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/landing/investment_opportunities_section.dart';
import '../../widgets/common/hajifund_logo.dart';

class InvestasiScreen extends StatefulWidget {
  const InvestasiScreen({super.key});

  @override
  State<InvestasiScreen> createState() => _InvestasiScreenState();
}

class _InvestasiScreenState extends State<InvestasiScreen> {
  String _selectedCategory = 'Semua';
  String _selectedRisk = 'Semua';
  double _minAmount = 100000;
  double _maxAmount = 10000000;

  final List<String> _categories = [
    'Semua',
    'UMKM',
    'Perdagangan',
    'Pertanian',
    'Teknologi',
    'Properti',
  ];

  final List<String> _riskLevels = [
    'Semua',
    'Rendah',
    'Sedang',
    'Tinggi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const HajifundLogo(
              width: 32,
              height: 32,
              showText: false,
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              'Peluang Investasi',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: const BoxDecoration(
                gradient: AppGradients.primaryGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Investasi Syariah Terpercaya',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Pilih peluang investasi yang sesuai dengan profil risiko dan target return Anda',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textOnPrimary.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  
                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Investasi',
                          'Rp 2.5 M',
                          Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: _buildStatCard(
                          'Rata-rata Return',
                          '12.5% p.a.',
                          Icons.percent,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: _buildStatCard(
                          'Proyek Aktif',
                          '48',
                          Icons.business_center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Filter Section
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Investasi',
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: AppSizes.md),
                  
                  // Category Filter
                  Text(
                    'Kategori',
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Wrap(
                    spacing: AppSizes.sm,
                    children: _categories.map((category) {
                      final isSelected = category == _selectedCategory;
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Risk Level Filter
                  Text(
                    'Tingkat Risiko',
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Wrap(
                    spacing: AppSizes.sm,
                    children: _riskLevels.map((risk) {
                      final isSelected = risk == _selectedRisk;
                      return FilterChip(
                        label: Text(risk),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedRisk = risk;
                          });
                        },
                        selectedColor: AppColors.accent.withOpacity(0.2),
                        checkmarkColor: AppColors.accent,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Amount Range
                  Text(
                    'Jumlah Investasi',
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  RangeSlider(
                    values: RangeValues(_minAmount, _maxAmount),
                    min: 100000,
                    max: 50000000,
                    divisions: 50,
                    labels: RangeLabels(
                      'Rp ${(_minAmount / 1000000).toStringAsFixed(1)}M',
                      'Rp ${(_maxAmount / 1000000).toStringAsFixed(1)}M',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minAmount = values.start;
                        _maxAmount = values.end;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            
            // Investment Opportunities
            const InvestmentOpportunitiesSection(),
            
            // Bottom Padding
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.textOnPrimary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.textOnPrimary,
            size: AppSizes.iconLg,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            value,
            style: AppTextStyles.h5.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
