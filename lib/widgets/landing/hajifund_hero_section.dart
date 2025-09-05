import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/constants.dart';
import '../common/app_button.dart';

class HajifundHeroSection extends StatelessWidget {
  const HajifundHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            const Color(0xFF0D4F3C), // Dark Islamic Green
            const Color(0xFF1B5E20), // Primary Green
            const Color(0xFF2E7D32), // Light Green
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          return Stack(
            children: [
              // HAJIFUND-style Islamic Pattern Background
              Positioned.fill(
                child: CustomPaint(
                  painter: HajifundPatternPainter(),
                ),
              ),
              
              // Main Content
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 1200 
                    ? AppSizes.xxl * 2 
                    : AppSizes.xl,
                  vertical: isMobile ? AppSizes.xxl : AppSizes.xxl * 2,
                ),
                child: isMobile ? _buildMobileLayout(constraints) : _buildDesktopLayout(constraints),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildDesktopLayout(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Content
        Expanded(
          flex: 3,
          child: _buildHajifundContent(constraints, false),
        ),
        
        const SizedBox(width: AppSizes.xxl),
        
        // Right Content - HAJIFUND-style Investment Dashboard
        Expanded(
          flex: 2,
          child: _buildInvestmentDashboard(),
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHajifundContent(constraints, true),
        const SizedBox(height: AppSizes.xxl),
        _buildInvestmentDashboard(),
      ],
    );
  }
  
  Widget _buildHajifundContent(BoxConstraints constraints, bool isMobile) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
        // HAJIFUND-style Badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700).withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: const Color(0xFFFFD700),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  color: Color(0xFF0D4F3C),
                  size: 12,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Terdaftar & Diawasi OJK',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppSizes.xl),
        
        // HAJIFUND Main Heading
        RichText(
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: AppTextStyles.h1.copyWith(
              color: Colors.white,
              fontSize: constraints.maxWidth > 768 ? 48 : 36,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
            children: [
              const TextSpan(text: 'Platform '),
              TextSpan(
                text: 'P2P Lending\n',
                style: TextStyle(
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: 'Syariah',
                style: TextStyle(
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const TextSpan(text: ' Terpercaya'),
            ],
          ),
        ),
        
        const SizedBox(height: AppSizes.lg),
        
        // HAJIFUND Subheading
        Text(
          'Investasi mudah, aman, dan menguntungkan dengan sistem bagi hasil sesuai prinsip syariah. Mulai dari Rp 100.000 dan dapatkan return hingga 18% per tahun.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withOpacity(0.95),
            fontSize: constraints.maxWidth > 768 ? 19 : 17,
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: AppSizes.xl),
        
        // HAJIFUND Stats Row
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Wrap(
            spacing: isMobile ? AppSizes.lg : AppSizes.xl,
            runSpacing: AppSizes.lg,
            children: [
              _buildHajifundStat('50K+', 'Pendana Aktif', '👥'),
              _buildHajifundStat('Rp 500M+', 'Dana Tersalurkan', '💰'),
              _buildHajifundStat('98.5%', 'Tingkat Keberhasilan', '📊'),
              _buildHajifundStat('18%', 'Return p.a', '📈'),
            ],
          ),
        ),
        
        const SizedBox(height: AppSizes.xl),
        
        // HAJIFUND CTA Buttons
        Column(
          crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            // Primary CTA
            Container(
              width: isMobile ? double.infinity : 280,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6F00), Color(0xFFFF8F00)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6F00).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Mulai Investasi Sekarang',
                      style: AppTextStyles.buttonLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Secondary CTA
            Container(
              width: isMobile ? double.infinity : 280,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
              ),
              child: ElevatedButton(
                onPressed: () => _scrollToFeatures(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_circle_outline, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Lihat Cara Kerja',
                      style: AppTextStyles.buttonLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSizes.xl),
        
        // HAJIFUND Trust Indicators
        Wrap(
          spacing: AppSizes.lg,
          runSpacing: AppSizes.md,
          children: [
            _buildTrustIndicator('🛡️', 'Aman & Terpercaya'),
            _buildTrustIndicator('🕌', '100% Syariah'),
            _buildTrustIndicator('📜', 'Tersertifikasi DSN-MUI'),
          ],
        ),
        ],
      ),
    );
  }
  
  Widget _buildInvestmentDashboard() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSizes.lg),
          
          // Investment Cards - Proper vertical layout
          _buildHajifundInvestmentCard(
            'UMKM Syariah Terpercaya',
            'Rp 200.000.000',
            '15.5%',
            '94%',
            const Color(0xFF4CAF50),
            Icons.store,
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          _buildHajifundInvestmentCard(
            'Proyek Pertanian Organik',
            'Rp 150.000.000',
            '16.2%',
            '87%',
            const Color(0xFF2196F3),
            Icons.agriculture,
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          _buildHajifundInvestmentCard(
            'Usaha Kuliner Halal',
            'Rp 100.000.000',
            '17.8%',
            '92%',
            const Color(0xFFFF9800),
            Icons.restaurant,
          ),
          
          const SizedBox(height: AppSizes.xl),
          
          // Badges in a row instead of positioned
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShariaBadge(),
              _buildReturnIndicator(),
              _buildSecurityBadge(),
            ],
          ),
          
          const SizedBox(height: AppSizes.lg),
        ],
      ),
    );
  }
  
  Widget _buildHajifundStat(String value, String label, String emoji) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: const Color(0xFFFFD700),
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildHajifundInvestmentCard(String title, String amount, String returnRate, String progress, Color color, IconData icon) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and badge
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'SYARIAH',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFFFFD700),
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Title
          Text(
            title,
            style: AppTextStyles.h6.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Amount
          Text(
            amount,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Return rate
          Row(
            children: [
              Icon(Icons.trending_up, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                'Return: $returnRate p.a',
                style: AppTextStyles.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Progress
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.textDisabled.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: double.parse(progress.replaceAll('%', '')) / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                progress,
                style: AppTextStyles.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildShariaBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.mosque,
              color: Color(0xFF0D4F3C),
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'SYARIAH',
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(0xFF0D4F3C),
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReturnIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.trending_up,
            color: Color(0xFF4CAF50),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            'Return',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          Text(
            '18%',
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF4CAF50),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSecurityBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.security,
            color: Color(0xFF2196F3),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            'OJK',
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(0xFF2196F3),
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrustIndicator(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  void _scrollToFeatures(BuildContext context) {
    // Implementation for smooth scrolling to features section
  }
}

class HajifundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw HAJIFUND-style Islamic geometric pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = 120.0;
    
    // Draw overlapping circles for Islamic pattern
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (3.14159 / 180);
      final x = centerX + (radius * 0.8) * cos(angle);
      final y = centerY + (radius * 0.8) * sin(angle);
      
      canvas.drawCircle(
        Offset(x, y),
        radius * 0.5,
        paint,
      );
    }
    
    // Draw central circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius * 0.6,
      paint,
    );
    
    // Add decorative dots
    for (double i = 0; i < size.width; i += 100) {
      for (double j = 0; j < size.height; j += 100) {
        canvas.drawCircle(
          Offset(i, j),
          3,
          Paint()
            ..color = Colors.white.withOpacity(0.02)
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
