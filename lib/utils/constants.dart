import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  static const String appName = 'HAJIFUND';
  static const String appTagline = 'P2P Lending Syariah Terpercaya';
  static const String appDescription = 'Platform peer-to-peer lending syariah yang aman, transparan, dan menguntungkan sesuai prinsip Islam';
  
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:8080/api/v1';
  static const String apiVersion = 'v1';
  
  // App Version
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  
  // Contact Information
  static const String contactEmail = 'support@hajifund.com';
  static const String contactPhone = '+62 21 5678 9012';
  static const String contactAddress = 'Jakarta, Indonesia';
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/hajifund';
  static const String twitterUrl = 'https://twitter.com/hajifund';
  static const String instagramUrl = 'https://instagram.com/hajifund';
  static const String linkedinUrl = 'https://linkedin.com/company/hajifund';
}

class AppColors {
  // HAJIFUND Primary Colors (Islamic Green Theme)
  static const Color primary = Color(0xFF00A86B); // Islamic Green
  static const Color primaryLight = Color(0xFF4CAF50); // Light Green
  static const Color primaryDark = Color(0xFF006B3C); // Dark Green
  static const Color primaryAccent = Color(0xFF2E7D32); // Forest Green
  
  // Secondary Colors (Gold/Yellow for Islamic theme)
  static const Color secondary = Color(0xFFFFD700); // Gold
  static const Color secondaryLight = Color(0xFFFFF176); // Light Gold
  static const Color secondaryDark = Color(0xFFF57F17); // Dark Gold
  
  // Accent Colors (Blue for trust and stability)
  static const Color accent = Color(0xFF1565C0); // Blue
  static const Color accentLight = Color(0xFF42A5F5); // Light Blue
  static const Color accentDark = Color(0xFF0D47A1); // Dark Blue
  
  // Neutral Colors (HAJIFUND Design System)
  static const Color background = Color(0xFFFAFBFC); // Off-white background
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color card = Color(0xFFFFFFFF); // Card background
  static const Color divider = Color(0xFFE5E7EB); // Light gray divider
  
  // Text Colors (HAJIFUND Typography)
  static const Color textPrimary = Color(0xFF111827); // Almost black
  static const Color textSecondary = Color(0xFF6B7280); // Medium gray
  static const Color textTertiary = Color(0xFF9CA3AF); // Light gray
  static const Color textHint = Color(0xFFD1D5DB); // Very light gray
  static const Color textDisabled = Color(0xFFE5E7EB); // Disabled text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White on primary
  
  // Status Colors (Islamic Finance Compliant)
  static const Color success = Color(0xFF10B981); // Success green
  static const Color warning = Color(0xFFF59E0B); // Warning amber
  static const Color error = Color(0xFFEF4444); // Error red
  static const Color info = Color(0xFF3B82F6); // Info blue
  
  // Investment Colors (P2P Lending Theme)
  static const Color profit = Color(0xFF10B981); // Profit green
  static const Color loss = Color(0xFFEF4444); // Loss red
  static const Color pending = Color(0xFFF59E0B); // Pending amber
  static const Color completed = Color(0xFF3B82F6); // Completed blue
  static const Color funded = Color(0xFF8B5CF6); // Funded purple
  
  // Sharia Compliance Colors
  static const Color halal = Color(0xFF10B981); // Halal green
  static const Color haram = Color(0xFFEF4444); // Haram red
  static const Color syariah = Color(0xFF00A86B); // Syariah green
  static const Color conventional = Color(0xFF6B7280); // Conventional gray
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF00A86B);
  static const Color gradientEnd = Color(0xFF4CAF50);
  static const Color gradientSecondaryStart = Color(0xFFFFD700);
  static const Color gradientSecondaryEnd = Color(0xFFFFF176);
}

class AppTextStyles {
  // HAJIFUND Typography System using Inter and Poppins fonts
  
  // Display Text (Hero sections)
  static TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: -0.5,
  );
  
  static TextStyle get displayMedium => GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.25,
  );
  
  static TextStyle get displaySmall => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.25,
  );
  
  // Headings
  static TextStyle get h1 => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get h2 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get h3 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get h4 => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get h5 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get h6 => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Body Text (Inter for readability)
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  // Button Text
  static TextStyle get buttonLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  static TextStyle get buttonMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.25,
  );
  
  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.25,
  );
  
  // Labels and Captions
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.1,
  );
  
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  // Caption
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // Overline (for tags and badges)
  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 1.5,
    textBaseline: TextBaseline.alphabetic,
  );
  
  // Special styles for HAJIFUND
  static TextStyle get brandTitle => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.2,
    letterSpacing: 1.2,
  );
  
  static TextStyle get brandSubtitle => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
    letterSpacing: 0.5,
  );
  
  // Financial/Numeric styles
  static TextStyle get currencyLarge => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.2,
  );
  
  static TextStyle get currencyMedium => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static TextStyle get currencySmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
}

class AppSizes {
  // HAJIFUND Design System Spacing (8px grid system)
  static const double xs = 4.0;   // 0.5 unit
  static const double sm = 8.0;   // 1 unit
  static const double md = 16.0;  // 2 units
  static const double lg = 24.0;  // 3 units
  static const double xl = 32.0;  // 4 units
  static const double xxl = 48.0; // 6 units
  static const double xxxl = 64.0; // 8 units
  
  // Border Radius (Modern rounded corners)
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;
  static const double radiusRound = 50.0;
  
  // Component Heights
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 52.0;
  
  static const double inputHeightSmall = 36.0;
  static const double inputHeightMedium = 44.0;
  static const double inputHeightLarge = 52.0;
  
  static const double cardHeightSmall = 120.0;
  static const double cardHeightMedium = 200.0;
  static const double cardHeightLarge = 300.0;
  
  // Layout Padding
  static const double paddingXs = 8.0;
  static const double paddingSm = 12.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;
  static const double paddingXxl = 48.0;
  
  // Screen Layout
  static const double screenPaddingMobile = 16.0;
  static const double screenPaddingTablet = 24.0;
  static const double screenPaddingDesktop = 32.0;
  
  // Container Constraints
  static const double maxContentWidth = 1200.0;
  static const double maxCardWidth = 400.0;
  static const double minButtonWidth = 120.0;
  
  // Navigation
  static const double navBarHeight = 64.0;
  static const double navBarHeightMobile = 56.0;
  static const double sideBarWidth = 280.0;
  static const double bottomNavHeight = 60.0;
  
  // Icons
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  
  // Avatar Sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 72.0;
  
  // Breakpoints
  static const double breakpointMobile = 768.0;
  static const double breakpointTablet = 1024.0;
  static const double breakpointDesktop = 1440.0;
}

class AppShadows {
  // HAJIFUND Shadow System (Modern elevation)
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];
  
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -2,
    ),
  ];
  
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];
  
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x19000000),
      offset: Offset(0, 12),
      blurRadius: 24,
      spreadRadius: -6,
    ),
  ];
  
  // Colored shadows for branding
  static const List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: Color(0x1A00A86B),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> secondaryShadow = [
    BoxShadow(
      color: Color(0x1AFFD700),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];
  
  // Legacy support
  static const List<BoxShadow> small = xs;
  static const List<BoxShadow> medium = md;
  static const List<BoxShadow> large = lg;
}

class AppGradients {
  // HAJIFUND Gradient System
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.gradientStart, AppColors.gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [AppColors.gradientSecondaryStart, AppColors.gradientSecondaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [AppColors.accent, AppColors.accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Hero section gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFF00A86B),
      Color(0xFF4CAF50),
      Color(0xFF81C784),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.6, 1.0],
  );
  
  // Card gradients
  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFAFBFC),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Success gradient
  static const LinearGradient successGradient = LinearGradient(
    colors: [AppColors.success, Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Warning gradient
  static const LinearGradient warningGradient = LinearGradient(
    colors: [AppColors.warning, Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Error gradient
  static const LinearGradient errorGradient = LinearGradient(
    colors: [AppColors.error, Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Islamic pattern overlay
  static const LinearGradient islamicOverlay = LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x1A00A86B),
      Color(0x00000000),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
}
