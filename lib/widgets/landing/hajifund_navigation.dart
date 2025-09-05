import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../common/app_button.dart';

class HajifundNavigation extends StatelessWidget {
  final bool isScrolled;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;
  final Function(String)? onSectionTap;

  const HajifundNavigation({
    super.key,
    required this.isScrolled,
    this.onLoginPressed,
    this.onRegisterPressed,
    this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isScrolled 
          ? Colors.white.withOpacity(0.95)
          : Colors.transparent,
        boxShadow: isScrolled
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
        child: Row(
          children: [
            // Logo Section
            _buildLogo(context),
            
            const Spacer(),
            
            // Navigation Menu
            if (MediaQuery.of(context).size.width > 768) ...[
              _buildNavItem('Beranda', () => Navigator.pushNamed(context, '/beranda')),
              _buildNavItem('Investasi', () => Navigator.pushNamed(context, '/investasi')),
              _buildNavItem('Pembiayaan', () => Navigator.pushNamed(context, '/pembiayaan')),
              _buildNavItem('Tentang', () => onSectionTap?.call('about')),
              _buildNavItem('Kontak', () => Navigator.pushNamed(context, '/kontak')),
              
              const SizedBox(width: AppSizes.lg),
              
              // Auth Buttons
              _buildAuthButtons(context),
            ] else ...[
              // Mobile Menu Button
              IconButton(
                onPressed: () => _showMobileMenu(context),
                icon: Icon(
                  Icons.menu,
                  color: isScrolled ? AppColors.primary : Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Row(
      children: [
        // Islamic Pattern Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.mosque,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HAJIFUND',
              style: AppTextStyles.h5.copyWith(
                color: isScrolled ? AppColors.primary : Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'P2P Lending Syariah',
              style: AppTextStyles.caption.copyWith(
                color: isScrolled 
                  ? AppColors.textSecondary 
                  : Colors.white.withOpacity(0.8),
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavItem(String title, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isScrolled ? AppColors.textPrimary : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButtons(BuildContext context) {
    return Row(
      children: [
        // Login Button
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isScrolled ? AppColors.primary : Colors.white,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AppButton(
            text: 'Masuk',
            variant: ButtonVariant.outlined,
            size: ButtonSize.small,
            onPressed: onLoginPressed,
            textColor: isScrolled ? AppColors.primary : Colors.white,
            borderColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
        ),
        
        const SizedBox(width: AppSizes.sm),
        
        // Register Button
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppButton(
            text: 'Daftar Sekarang',
            size: ButtonSize.small,
            onPressed: onRegisterPressed,
            backgroundColor: Colors.transparent,
            textStyle: AppTextStyles.buttonSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            
            // Menu Items
            _buildMobileMenuItem('Beranda', Icons.home, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/beranda');
            }),
            _buildMobileMenuItem('Investasi', Icons.trending_up, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/investasi');
            }),
            _buildMobileMenuItem('Pembiayaan', Icons.account_balance_wallet, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/pembiayaan');
            }),
            _buildMobileMenuItem('Tentang', Icons.info_outline, () {
              Navigator.pop(context);
              onSectionTap?.call('about');
            }),
            _buildMobileMenuItem('Kontak', Icons.contact_phone, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/kontak');
            }),
            
            const SizedBox(height: AppSizes.lg),
            const Divider(),
            const SizedBox(height: AppSizes.lg),
            
            // Auth Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Masuk',
                    variant: ButtonVariant.outlined,
                    onPressed: () {
                      Navigator.pop(context);
                      onLoginPressed?.call();
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppButton(
                      text: 'Daftar',
                      onPressed: () {
                        Navigator.pop(context);
                        onRegisterPressed?.call();
                      },
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
