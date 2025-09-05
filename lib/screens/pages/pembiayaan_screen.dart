import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common/hajifund_logo.dart';

class PembiayaanScreen extends StatefulWidget {
  const PembiayaanScreen({super.key});

  @override
  State<PembiayaanScreen> createState() => _PembiayaanScreenState();
}

class _PembiayaanScreenState extends State<PembiayaanScreen> {

  final List<Map<String, dynamic>> _financingTypes = [
    {
      'title': 'Pembiayaan UMKM Syariah',
      'subtitle': 'Modal usaha untuk pengembangan UMKM sesuai prinsip syariah Islam',
      'icon': Icons.store_mall_directory,
      'color': AppColors.primary,
      'features': [
        'Plafon pembiayaan hingga Rp 500 juta',
        'Tenor fleksibel 12-60 bulan',
        'Proses persetujuan 3-7 hari kerja',
        'Tanpa agunan untuk nominal tertentu',
        'Akad Mudharabah dan Musyarakah',
        'Bebas riba dan sesuai fatwa DSN-MUI',
      ],
    },
    {
      'title': 'Usaha Kuliner Halal',
      'subtitle': 'Pembiayaan khusus untuk pengembangan bisnis kuliner halal dan thayyib',
      'icon': Icons.restaurant_menu,
      'color': AppColors.accent,
      'features': [
        'Plafon pembiayaan hingga Rp 1 miliar',
        'Tenor disesuaikan jenis usaha 6-36 bulan',
        'Margin bagi hasil yang kompetitif',
        'Sertifikasi halal MUI didukung',
        'Konsultasi bisnis kuliner gratis',
        'Jaringan distribusi halal terintegrasi',
      ],
    },
    {
      'title': 'Pertanian Organic',
      'subtitle': 'Dukungan modal untuk pertanian organik dan ramah lingkungan',
      'icon': Icons.eco,
      'color': AppColors.success,
      'features': [
        'Plafon disesuaikan kebutuhan lahan',
        'Tenor mengikuti siklus tanam dan panen',
        'Fokus pada produk halal dan organik',
        'Pendampingan teknis dari ahli pertanian',
        'Akses ke pasar premium organik',
        'Program sustainability dan lingkungan',
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
                  
                  // Responsive Layout for Financing Cards
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = constraints.maxWidth;
                      
                      if (screenWidth < AppSizes.breakpointTablet) {
                        // Mobile Layout: Single column with proper spacing
                        return Column(
                          children: _financingTypes.asMap().entries.map((entry) {
                            final index = entry.key;
                            final financing = entry.value;
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                bottom: index < _financingTypes.length - 1 ? AppSizes.xl : 0,
                              ),
                              child: _buildFinancingCard(financing),
                            );
                          }).toList(),
                        );
                      } else if (screenWidth < AppSizes.breakpointDesktop) {
                        // Tablet Layout: 2 columns
                        return Wrap(
                          spacing: AppSizes.xl,
                          runSpacing: AppSizes.xl,
                          alignment: WrapAlignment.center,
                          children: _financingTypes.map((financing) {
                            return Container(
                              width: (screenWidth - AppSizes.xl * 3) / 2, // 2 columns with spacing
                              constraints: BoxConstraints(
                                minWidth: 300,
                                maxWidth: 450,
                              ),
                              child: _buildFinancingCard(financing),
                            );
                          }).toList(),
                        );
                      } else {
                        // Desktop Layout: 3 columns with proper spacing
                        return Wrap(
                          spacing: AppSizes.xl,
                          runSpacing: AppSizes.xl,
                          alignment: WrapAlignment.start,
                          children: _financingTypes.map((financing) {
                            return Container(
                              width: (screenWidth - AppSizes.xl * 4) / 3, // 3 columns with proper spacing
                              constraints: BoxConstraints(
                                minWidth: 280,
                                maxWidth: 400,
                              ),
                              child: _buildFinancingCard(financing),
                            );
                          }).toList(),
                        );
                      }
                    },
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
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      margin: const EdgeInsets.all(AppSizes.xs), // Add margin to prevent touching
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: AppShadows.md,
        border: Border.all(
          color: financing['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Icon and Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: AppTextStyles.h4.copyWith(
                        color: financing['color'],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      financing['subtitle'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Features Section
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: financing['color'].withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keunggulan:',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: financing['color'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                ...financing['features'].map<Widget>((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.check_circle,
                              color: financing['color'],
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTextStyles.bodyMedium.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to specific financing application
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: financing['color'],
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.md,
                  horizontal: AppSizes.lg,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                elevation: 2,
              ),
              child: Text(
                'Pelajari Lebih Lanjut',
                style: AppTextStyles.buttonMedium,
              ),
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
