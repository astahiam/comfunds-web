import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/constants.dart';
import '../common/app_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            const Color(0xFF1B5E20), // Dark Islamic Green
            const Color(0xFF2E7D32), // Primary Green
            const Color(0xFF4CAF50), // Light Green
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          return Stack(
            children: [
              // Background Islamic Pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: IslamicPatternPainter(),
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
          child: _buildHeroContent(constraints, false),
        ),
        
        const SizedBox(width: AppSizes.xxl),
        
        // Right Content - Modern Islamic Finance Illustration
        Expanded(
          flex: 2,
          child: _buildHeroIllustration(),
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeroContent(constraints, true),
        const SizedBox(height: AppSizes.xxl),
        _buildHeroIllustration(),
      ],
    );
  }
  
  Widget _buildHeroContent(BoxConstraints constraints, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Islamic Badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700), // Gold color for Islamic symbol
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mosque,
                  color: Color(0xFF1B5E20),
                  size: 12,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                '🌙 Sharia-Compliant Platform',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppSizes.xl),
        
        // Main Heading with Islamic Touch
        RichText(
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: AppTextStyles.h1.copyWith(
              color: Colors.white,
              fontSize: constraints.maxWidth > 768 ? 52 : 38,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
            children: [
              const TextSpan(text: 'Investasi '),
              TextSpan(
                text: 'Halal',
                style: TextStyle(
                  color: const Color(0xFFFFD700), // Gold highlight
                  fontWeight: FontWeight.w900,
                ),
              ),
              const TextSpan(text: '\nUntuk Masa Depan\n'),
              TextSpan(
                text: 'Berkelanjutan',
                style: TextStyle(
                  color: const Color(0xFF81C784), // Light green
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppSizes.lg),
        
        // Enhanced Subheading
        Text(
          'Bergabunglah dengan ribuan anggota koperasi yang membangun kekayaan melalui investasi bagi hasil yang transparan dan sesuai syariah Islam.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontSize: constraints.maxWidth > 768 ? 18 : 16,
            height: 1.7,
            fontWeight: FontWeight.w400,
          ),
        ),
        
        const SizedBox(height: AppSizes.xl),
        
        // Enhanced Stats Row
        Wrap(
          spacing: isMobile ? AppSizes.lg : AppSizes.xxl,
          runSpacing: AppSizes.lg,
          children: [
            _buildEnhancedStat('25K+', 'Anggota Aktif', Icons.people),
            _buildEnhancedStat('1.2K+', 'Proyek Didanai', Icons.business_center),
            _buildEnhancedStat('18.5%', 'Rata-rata Return', Icons.trending_up),
          ],
        ),
        
        const SizedBox(height: AppSizes.xl),
        
        // Enhanced CTA Buttons
        Wrap(
          spacing: AppSizes.md,
          runSpacing: AppSizes.md,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFF6F00), const Color(0xFFFFB74D)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6F00).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Builder(
                builder: (context) => AppButton(
                  text: 'Mulai Investasi',
                  size: ButtonSize.large,
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                backgroundColor: Colors.transparent,
                textStyle: AppTextStyles.buttonLarge.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Builder(
                builder: (context) => AppButton(
                  text: 'Pelajari Lebih Lanjut',
                  size: ButtonSize.large,
                  variant: ButtonVariant.outlined,
                  onPressed: () => _scrollToFeatures(context),
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                borderColor: Colors.transparent,
                textStyle: AppTextStyles.buttonLarge.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSizes.xl),
        
        // Trust Indicators with Islamic Elements
        Wrap(
          spacing: AppSizes.lg,
          runSpacing: AppSizes.md,
          children: [
            _buildTrustIndicator(Icons.security, 'Keamanan Bank'),
            _buildTrustIndicator(Icons.verified_user, 'Platform Teregulasi'),
            _buildTrustIndicator(Icons.mosque, '100% Halal'),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedStat(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFFD700),
            size: 24,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 28,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrustIndicator(IconData icon, String text) {
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
          Icon(
            icon,
            color: const Color(0xFFFFD700),
            size: 16,
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return Container(
      height: 500,
      child: Stack(
        children: [
          // Background glow effect
          Positioned.fill(
            child: Container(
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
            ),
          ),
          
          // Investment cards with Islamic design
          Positioned(
            top: 50,
            left: 20,
            child: _buildModernInvestmentCard(
              'Usaha Kuliner Halal',
              'Rp 150.000.000',
              '92%',
              const Color(0xFF4CAF50),
              Icons.restaurant,
            ),
          ),
          
          Positioned(
            top: 180,
            right: 30,
            child: _buildModernInvestmentCard(
              'Teknologi Fintech',
              'Rp 250.000.000',
              '78%',
              const Color(0xFF2196F3),
              Icons.computer,
            ),
          ),
          
          Positioned(
            bottom: 80,
            left: 40,
            child: _buildModernInvestmentCard(
              'Pertanian Organik',
              'Rp 100.000.000',
              '85%',
              const Color(0xFFFF9800),
              Icons.agriculture,
            ),
          ),
          
          // Floating elements
          Positioned(
            top: 120,
            right: 80,
            child: _buildFloatingElement(Icons.trending_up, const Color(0xFF4CAF50)),
          ),
          
          Positioned(
            bottom: 200,
            right: 20,
            child: _buildFloatingElement(Icons.security, const Color(0xFFFFD700)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildModernInvestmentCard(String title, String amount, String progress, Color color, IconData icon) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h6.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Investasi Syariah',
                      style: AppTextStyles.bodySmall.copyWith(
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
            amount,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          
          const SizedBox(height: AppSizes.md),
          
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
              const SizedBox(width: AppSizes.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$progress Terdanai',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFloatingElement(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }

  void _scrollToFeatures(BuildContext context) {
    // Implementation for smooth scrolling to features section
  }
}

class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw Islamic geometric pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = 100.0;
    
    // Draw multiple overlapping circles (Islamic geometric pattern)
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final x = centerX + (radius * 0.7) * cos(angle);
      final y = centerY + (radius * 0.7) * sin(angle);
      
      canvas.drawCircle(
        Offset(x, y),
        radius * 0.6,
        paint,
      );
    }
    
    // Draw central circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius * 0.8,
      paint,
    );
    
    // Draw decorative lines
    for (double i = 0; i < size.width; i += 80) {
      for (double j = 0; j < size.height; j += 80) {
        canvas.drawCircle(
          Offset(i, j),
          2,
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

