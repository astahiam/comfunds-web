import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/landing/hajifund_hero_section.dart';
import '../../widgets/landing/hajifund_features_section.dart';
import '../../widgets/landing/statistics_section.dart';
import '../../widgets/landing/how_it_works_section.dart';
import '../../widgets/landing/testimonials_section.dart';
import '../../widgets/landing/cta_section.dart';
import '../../widgets/landing/footer_section.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'HAJIFUND',
          style: AppTextStyles.brandTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: Text(
              'Masuk',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSizes.sm),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
              ),
              child: Text(
                'Daftar',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Section
            const HajifundHeroSection(),
            
            // Features Section
            const HajifundFeaturesSection(),
            
            // Statistics Section
            const StatisticsSection(),
            
            // How It Works Section
            const HowItWorksSection(),
            
            // Testimonials Section
            const TestimonialsSection(),
            
            // CTA Section
            const CTASection(),
            
            // Footer Section
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
