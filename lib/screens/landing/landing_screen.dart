import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';
import '../../widgets/common/app_button.dart';
// import '../../widgets/common/app_text_field.dart';
import '../../widgets/landing/hajifund_navigation.dart';
import '../../widgets/landing/hajifund_hero_section.dart';
import '../../widgets/landing/hajifund_features_section.dart';
import '../../widgets/landing/statistics_section.dart';
import '../../widgets/landing/how_it_works_section.dart';
import '../../widgets/landing/testimonials_section.dart';
import '../../widgets/landing/cta_section.dart';
import '../../widgets/landing/footer_section.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isScrolled = _scrollController.offset > 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // HAJIFUND Navigation Bar
          SliverAppBar(
            expandedHeight: AppSizes.navBarHeight,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: _isScrolled 
                    ? null 
                    : AppGradients.heroGradient,
                ),
                child: HajifundNavigation(
                  isScrolled: _isScrolled,
                  onLoginPressed: () => Navigator.pushNamed(context, '/login'),
                  onRegisterPressed: () => Navigator.pushNamed(context, '/register'),
                  onSectionTap: _scrollToSection,
                ),
              ),
            ),
          ),
          
          // HAJIFUND Hero Section
          const SliverToBoxAdapter(
            child: HajifundHeroSection(),
          ),
          
          // Statistics Section
          const SliverToBoxAdapter(
            child: StatisticsSection(),
          ),
          
          // HAJIFUND Features Section
          const SliverToBoxAdapter(
            child: HajifundFeaturesSection(),
          ),
          
          // How It Works Section
          const SliverToBoxAdapter(
            child: HowItWorksSection(),
          ),
          
          // Testimonials Section
          const SliverToBoxAdapter(
            child: TestimonialsSection(),
          ),
          
          // CTA Section
          const SliverToBoxAdapter(
            child: CTASection(),
          ),
          
          // Footer Section
          const SliverToBoxAdapter(
            child: FooterSection(),
          ),
        ],
      ),
    );
  }

  void _scrollToSection(String sectionId) {
    // Implementation for smooth scrolling to sections
    // This would be implemented with GlobalKey for each section
  }
}
