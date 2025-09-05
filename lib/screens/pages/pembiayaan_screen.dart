import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common/hajifund_logo.dart';

class PembiayaanScreen extends StatefulWidget {
  const PembiayaanScreen({super.key});

  @override
  State<PembiayaanScreen> createState() => _PembiayaanScreenState();
}

class _PembiayaanScreenState extends State<PembiayaanScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _financingTypes = [
    {
      'title': 'Pembiayaan UMKM',
      'subtitle': 'Untuk pengembangan usaha mikro, kecil, dan menengah',
      'icon': Icons.store,
      'color': AppColors.primary,
      'features': [
        'Plafon hingga Rp 500 juta',
        'Tenor fleksibel 12-60 bulan',
        'Proses cepat 3-7 hari kerja',
        'Tanpa agunan untuk nominal tertentu',
      ],
    },
    {
      'title': 'Pembiayaan Perdagangan',
      'subtitle': 'Modal kerja untuk aktivitas perdagangan',
      'icon': Icons.shopping_cart,
      'color': AppColors.accent,
      'features': [
        'Plafon hingga Rp 1 miliar',
        'Tenor 6-36 bulan',
        'Margin kompetitif',
        'Proses approval yang cepat',
      ],
    },
    {
      'title': 'Pembiayaan Pertanian',
      'subtitle': 'Mendukung sektor pertanian dan agribisnis',
      'icon': Icons.agriculture,
      'color': AppColors.success,
      'features': [
        'Plafon disesuaikan kebutuhan',
        'Tenor mengikuti siklus panen',
        'Khusus sektor halal',
        'Pendampingan teknis',
      ],
    },
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
              'Pembiayaan Syariah',
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
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.xl),
              decoration: const BoxDecoration(
                gradient: AppGradients.primaryGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wujudkan Impian Bisnis Anda',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    'Dapatkan pembiayaan syariah yang sesuai dengan prinsip Islam untuk mengembangkan usaha Anda',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textOnPrimary.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to application form
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.xl,
                        vertical: AppSizes.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      ),
                    ),
                    child: Text(
                      'Ajukan Pembiayaan',
                      style: AppTextStyles.buttonLarge,
                    ),
                  ),
                ],
              ),
            ),
            
            // Requirements Section
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Syarat dan Ketentuan',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppSizes.md),
                  _buildRequirementCard(),
                ],
              ),
            ),
            
            // Financing Types
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jenis Pembiayaan',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppSizes.md),
                  SizedBox(
                    height: 400,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _financingTypes.length,
                      itemBuilder: (context, index) {
                        return _buildFinancingCard(_financingTypes[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _financingTypes.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Process Steps
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proses Pengajuan',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppSizes.md),
                  _buildProcessSteps(),
                ],
              ),
            ),
            
            // CTA Section
            Container(
              margin: const EdgeInsets.all(AppSizes.lg),
              padding: const EdgeInsets.all(AppSizes.xl),
              decoration: BoxDecoration(
                gradient: AppGradients.secondaryGradient,
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
              child: Column(
                children: [
                  Text(
                    'Siap Mengajukan Pembiayaan?',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    'Tim ahli kami siap membantu Anda menemukan solusi pembiayaan yang tepat',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to application form
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.xl,
                            vertical: AppSizes.md,
                          ),
                        ),
                        child: const Text('Mulai Pengajuan'),
                      ),
                      const SizedBox(width: AppSizes.md),
                      OutlinedButton(
                        onPressed: () {
                          // Contact support
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.xl,
                            vertical: AppSizes.md,
                          ),
                        ),
                        child: const Text('Konsultasi'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist,
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Persyaratan Umum',
                style: AppTextStyles.h5,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          ...[
            'WNI berusia minimal 21 tahun',
            'Memiliki usaha yang beroperasi minimal 1 tahun',
            'Usaha sesuai dengan prinsip syariah',
            'Memiliki dokumen legalitas usaha',
            'Laporan keuangan 6 bulan terakhir',
          ].map((requirement) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        requirement,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFinancingCard(Map<String, dynamic> financing) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: AppShadows.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: financing['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Icon(
                  financing['icon'],
                  color: financing['color'],
                  size: AppSizes.iconLg,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      financing['title'],
                      style: AppTextStyles.h4,
                    ),
                    Text(
                      financing['subtitle'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'Keunggulan:',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppSizes.sm),
          ...financing['features'].map<Widget>((feature) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.xs),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.secondary,
                      size: 16,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: AppSizes.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to specific financing application
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: financing['color'],
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
              ),
              child: const Text('Pelajari Lebih Lanjut'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessSteps() {
    final steps = [
      {
        'title': 'Pengajuan Online',
        'description': 'Isi formulir dan upload dokumen',
        'icon': Icons.web,
      },
      {
        'title': 'Verifikasi',
        'description': 'Tim kami akan memverifikasi data',
        'icon': Icons.verified_user,
      },
      {
        'title': 'Survey',
        'description': 'Survey lapangan dan analisis',
        'icon': Icons.location_searching,
      },
      {
        'title': 'Persetujuan',
        'description': 'Keputusan dan pencairan dana',
        'icon': Icons.approval,
      },
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      step['icon'] as IconData,
                      color: AppColors.textOnPrimary,
                      size: 20,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: AppColors.primary.withOpacity(0.3),
                  ),
              ],
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: AppTextStyles.h5,
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      step['description'] as String,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
