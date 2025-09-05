import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class HajifundLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  final Color? textColor;
  final bool isCompact;

  const HajifundLogo({
    super.key,
    this.width,
    this.height,
    this.showText = true,
    this.textColor,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Container with Islamic Design
        Container(
          width: width ?? (isCompact ? 32 : 48),
          height: height ?? (isCompact ? 32 : 48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isCompact ? 6 : 8),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2E7D32), // Dark Green
                Color(0xFF4CAF50), // Light Green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Islamic Pattern Background
              CustomPaint(
                size: Size(
                  width ?? (isCompact ? 32 : 48),
                  height ?? (isCompact ? 32 : 48),
                ),
                painter: IslamicLogoPatternPainter(),
              ),
              // Central Islamic Symbol
              Container(
                width: (width ?? (isCompact ? 32 : 48)) * 0.6,
                height: (height ?? (isCompact ? 32 : 48)) * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.mosque,
                  color: Color(0xFF2E7D32),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        
        if (showText) ...[
          SizedBox(width: isCompact ? AppSizes.xs : AppSizes.sm),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HAJIFUND',
                style: (isCompact ? AppTextStyles.bodyMedium : AppTextStyles.h5).copyWith(
                  color: textColor ?? AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              if (!isCompact) ...[
                Text(
                  'P2P Lending Syariah',
                  style: AppTextStyles.caption.copyWith(
                    color: textColor?.withOpacity(0.7) ?? AppColors.textSecondary,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class IslamicLogoPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw geometric Islamic patterns
    // Octagon pattern
    final path = Path();
    final radius = size.width * 0.35;
    
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
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Inner circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius * 0.6,
      paint,
    );
    
    // Four corner decorative elements
    final cornerSize = size.width * 0.1;
    final corners = [
      Offset(cornerSize, cornerSize),
      Offset(size.width - cornerSize, cornerSize),
      Offset(size.width - cornerSize, size.height - cornerSize),
      Offset(cornerSize, size.height - cornerSize),
    ];
    
    for (final corner in corners) {
      canvas.drawCircle(corner, 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Alternative logo for light backgrounds
class HajifundLogoLight extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  final bool isCompact;

  const HajifundLogoLight({
    super.key,
    this.width,
    this.height,
    this.showText = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return HajifundLogo(
      width: width,
      height: height,
      showText: showText,
      textColor: AppColors.primary,
      isCompact: isCompact,
    );
  }
}

// Alternative logo for dark backgrounds
class HajifundLogoDark extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  final bool isCompact;

  const HajifundLogoDark({
    super.key,
    this.width,
    this.height,
    this.showText = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return HajifundLogo(
      width: width,
      height: height,
      showText: showText,
      textColor: Colors.white,
      isCompact: isCompact,
    );
  }
}

// dart:math is now imported, so cos and sin functions are available
