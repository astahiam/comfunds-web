import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../common/app_button.dart';

class InvestmentOpportunitiesSection extends StatelessWidget {
  const InvestmentOpportunitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xl,
        vertical: AppSizes.xxxl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade50,
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // Section Header
          _buildSectionHeader(),
          const SizedBox(height: AppSizes.xxxl),
          
          // Investment Cards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1200) {
                return _buildDesktopLayout();
              } else if (constraints.maxWidth > 768) {
                return _buildTabletLayout();
              } else {
                return _buildMobileLayout();
              }
            },
          ),
          
          const SizedBox(height: AppSizes.xxxl),
          
          // View All Button
          _buildViewAllButton(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: const Color(0xFF2E7D32).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.mosque,
                color: const Color(0xFF2E7D32),
                size: 16,
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                'Investasi Syariah Terpercaya',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        Text(
          'Peluang Investasi Terbaik',
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          'Temukan berbagai peluang investasi syariah dengan return yang menarik\ndan sesuai prinsip Islam',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(child: _buildInvestmentCard(_investmentData[0])),
        const SizedBox(width: AppSizes.lg),
        Expanded(child: _buildInvestmentCard(_investmentData[1])),
        const SizedBox(width: AppSizes.lg),
        Expanded(child: _buildInvestmentCard(_investmentData[2])),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInvestmentCard(_investmentData[0])),
            const SizedBox(width: AppSizes.lg),
            Expanded(child: _buildInvestmentCard(_investmentData[1])),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          child: _buildInvestmentCard(_investmentData[2]),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildInvestmentCard(_investmentData[0]),
        const SizedBox(height: AppSizes.lg),
        _buildInvestmentCard(_investmentData[1]),
        const SizedBox(height: AppSizes.lg),
        _buildInvestmentCard(_investmentData[2]),
      ],
    );
  }

  Widget _buildInvestmentCard(InvestmentData data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: data.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Islamic Pattern Overlay
                Positioned.fill(
                  child: CustomPaint(
                    painter: IslamicPatternPainter(),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          data.category,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Title and Return
                      Text(
                        data.title,
                        style: AppTextStyles.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        'Return hingga ${data.returnRate}% p.a',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  data.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                
                // Metrics Row
                Row(
                  children: [
                    Expanded(
                      child: _buildMetric(
                        'Min. Investasi',
                        data.minInvestment,
                        Icons.account_balance_wallet,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.divider,
                    ),
                    Expanded(
                      child: _buildMetric(
                        'Tenor',
                        data.tenor,
                        Icons.schedule,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSizes.lg),
                
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress Pendanaan',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${data.progress}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xs),
                    LinearProgressIndicator(
                      value: data.progress / 100,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        data.gradientColors.first,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSizes.lg),
                
                // Invest Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: data.gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppButton(
                      text: 'Investasi Sekarang',
                      onPressed: () {
                        // Handle investment action
                      },
                      backgroundColor: Colors.transparent,
                      textStyle: AppTextStyles.buttonMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildViewAllButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppButton(
        text: 'Lihat Semua Peluang Investasi',
        variant: ButtonVariant.outlined,
        size: ButtonSize.large,
        onPressed: () {
          // Handle view all action
        },
        textColor: AppColors.primary,
        borderColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static final List<InvestmentData> _investmentData = [
    InvestmentData(
      category: 'UMKM',
      title: 'Usaha Kuliner Syariah',
      description: 'Investasi pada usaha kuliner halal dengan sistem bagi hasil yang menguntungkan',
      returnRate: '18',
      minInvestment: 'Rp 100.000',
      tenor: '12 Bulan',
      progress: 75,
      gradientColors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
    ),
    InvestmentData(
      category: 'Properti',
      title: 'Pembiayaan Rumah Syariah',
      description: 'Pembiayaan properti residensial dengan akad mudharabah yang aman dan terpercaya',
      returnRate: '15',
      minInvestment: 'Rp 1.000.000',
      tenor: '24 Bulan',
      progress: 60,
      gradientColors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    ),
    InvestmentData(
      category: 'Perdagangan',
      title: 'Modal Usaha Dagang',
      description: 'Pembiayaan modal kerja untuk usaha perdagangan dengan prinsip syariah',
      returnRate: '20',
      minInvestment: 'Rp 500.000',
      tenor: '18 Bulan',
      progress: 85,
      gradientColors: [Color(0xFFE65100), Color(0xFFFF9800)],
    ),
  ];
}

class InvestmentData {
  final String category;
  final String title;
  final String description;
  final String returnRate;
  final String minInvestment;
  final String tenor;
  final int progress;
  final List<Color> gradientColors;

  InvestmentData({
    required this.category,
    required this.title,
    required this.description,
    required this.returnRate,
    required this.minInvestment,
    required this.tenor,
    required this.progress,
    required this.gradientColors,
  });
}

class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw geometric Islamic patterns
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = 30.0;

    // Draw star pattern
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
    
    // Draw additional decorative elements
    canvas.drawCircle(Offset(centerX, centerY), radius * 0.5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
