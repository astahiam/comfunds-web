import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class HajifundFeaturesSection extends StatelessWidget {
  const HajifundFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xl,
        vertical: AppSizes.xxl * 2,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // HAJIFUND-style Section Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'KEUNGGULAN PLATFORM',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
              children: [
                const TextSpan(text: 'Mengapa Memilih '),
                TextSpan(
                  text: 'P2P Lending Syariah',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Platform peer-to-peer lending syariah yang menghubungkan pendana dengan peminjam berdasarkan prinsip keuangan Islam yang adil dan transparan.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                fontSize: 18,
                height: 1.6,
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.xxl),
          
          // HAJIFUND-style Features Grid
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: constraints.maxWidth > 1200 ? 4 : 
                               constraints.maxWidth > 768 ? 3 : 
                               constraints.maxWidth > 480 ? 2 : 1,
                crossAxisSpacing: AppSizes.xl,
                mainAxisSpacing: AppSizes.xl,
                childAspectRatio: constraints.maxWidth > 768 ? 1.1 : 1.3,
                children: const [
                  HajifundFeatureCard(
                    icon: Icons.mosque,
                    title: 'Akad Syariah',
                    description: 'Menggunakan akad mudharabah dan musyarakah yang sesuai dengan prinsip syariah Islam.',
                    color: Color(0xFF4CAF50),
                    gradient: [Color(0xFF4CAF50), Color(0xFF81C784)],
                  ),
                  HajifundFeatureCard(
                    icon: Icons.security,
                    title: 'Terdaftar OJK',
                    description: 'Terdaftar dan diawasi oleh Otoritas Jasa Keuangan untuk keamanan investasi Anda.',
                    color: Color(0xFF2196F3),
                    gradient: [Color(0xFF2196F3), Color(0xFF42A5F5)],
                  ),
                  HajifundFeatureCard(
                    icon: Icons.trending_up,
                    title: 'Return Kompetitif',
                    description: 'Dapatkan return hingga 18% per tahun dengan sistem bagi hasil yang transparan.',
                    color: Color(0xFFFF9800),
                    gradient: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                  ),
                  HajifundFeatureCard(
                    icon: Icons.speed,
                    title: 'Proses Cepat',
                    description: 'Pendanaan dan pencairan dana yang cepat dengan teknologi digital terdepan.',
                    color: Color(0xFF9C27B0),
                    gradient: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
                  ),
                  HajifundFeatureCard(
                    icon: Icons.shield,
                    title: 'Mitigasi Risiko',
                    description: 'Sistem penilaian kredit yang ketat dan diversifikasi portofolio untuk meminimalisir risiko.',
                    color: Color(0xFFE91E63),
                    gradient: [Color(0xFFE91E63), Color(0xFFF06292)],
                  ),
                  HajifundFeatureCard(
                    icon: Icons.mobile_friendly,
                    title: 'Mudah Digunakan',
                    description: 'Platform yang user-friendly dengan akses 24/7 melalui web dan aplikasi mobile.',
                    color: Color(0xFF00BCD4),
                    gradient: [Color(0xFF00BCD4), Color(0xFF4DD0E1)],
                  ),
                  HajifundFeatureCard(
                    icon: Icons.analytics,
                    title: 'Laporan Transparan',
                    description: 'Laporan keuangan dan kinerja investasi yang transparan dan real-time.',
                    color: Color(0xFF795548),
                    gradient: [Color(0xFF795548), Color(0xFFA1887F)],
                  ),
                  HajifundFeatureCard(
                    icon: Icons.support_agent,
                    title: 'Customer Service',
                    description: 'Tim customer service yang responsif dan berpengalaman dalam keuangan syariah.',
                    color: Color(0xFF607D8B),
                    gradient: [Color(0xFF607D8B), Color(0xFF90A4AE)],
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: AppSizes.xxl * 2),
          
          // HAJIFUND Investment Calculator Section
          Container(
            padding: const EdgeInsets.all(AppSizes.xl * 1.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.primary.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                // Calculator Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calculate,
                        color: Color(0xFF1B5E20),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Text(
                      'Kalkulator Investasi Syariah',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSizes.xl),
                
                // Calculator Content
                LayoutBuilder(
                  builder: (context, constraints) {
                    return constraints.maxWidth > 768 
                      ? Row(
                          children: [
                            Expanded(child: _buildCalculatorExample()),
                            const SizedBox(width: AppSizes.xl),
                            Expanded(child: _buildInvestmentBenefits()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildCalculatorExample(),
                            const SizedBox(height: AppSizes.xl),
                            _buildInvestmentBenefits(),
                          ],
                        );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorExample() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Simulasi Investasi',
            style: AppTextStyles.h5.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Investment amount
          _buildCalculatorRow(
            'Jumlah Investasi',
            'Rp 10.000.000',
            Icons.account_balance_wallet,
            const Color(0xFF2196F3),
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Duration
          _buildCalculatorRow(
            'Jangka Waktu',
            '12 Bulan',
            Icons.schedule,
            const Color(0xFF9C27B0),
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Return rate
          _buildCalculatorRow(
            'Estimasi Return',
            '16% per tahun',
            Icons.trending_up,
            const Color(0xFF4CAF50),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Divider
          Container(
            height: 1,
            color: AppColors.textDisabled.withOpacity(0.3),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Result
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimasi Keuntungan',
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Rp 1.600.000',
                style: AppTextStyles.h5.copyWith(
                  color: const Color(0xFFFF6F00),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Keuntungan Investasi P2P Lending Syariah',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        
        const SizedBox(height: AppSizes.lg),
        
        ...[
          'Return kompetitif hingga 18% per tahun',
          'Investasi minimal mulai dari Rp 100.000',
          'Diversifikasi portofolio otomatis',
          'Proses yang mudah dan transparan',
          'Sesuai dengan prinsip syariah Islam',
          'Terdaftar dan diawasi OJK',
        ].map((benefit) => Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.md),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  benefit,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}

class HajifundFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<Color> gradient;

  const HajifundFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with gradient background
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Title
          Text(
            title,
            style: AppTextStyles.h5.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          
          const SizedBox(height: AppSizes.sm),
          
          // Description
          Expanded(
            child: Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
                fontSize: 14,
              ),
            ),
          ),
          
          // Accent line
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
