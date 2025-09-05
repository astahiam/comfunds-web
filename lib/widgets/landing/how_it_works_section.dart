import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

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
          // Enhanced Section Header
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
              'CARA KERJA',
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
                const TextSpan(text: 'Mulai Investasi '),
                TextSpan(
                  text: 'Syariah',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
                const TextSpan(text: '\nHanya 4 Langkah'),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Proses sederhana untuk memulai perjalanan investasi sesuai syariah Islam Anda bersama komunitas koperasi.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                fontSize: 18,
                height: 1.6,
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.xxl),
          
          // Modern Steps with Islamic Design
          LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth > 768
                ? _buildHorizontalSteps()
                : _buildVerticalSteps();
            },
          ),
          
          const SizedBox(height: AppSizes.xxl),
          
          // CTA Section
          Container(
            padding: const EdgeInsets.all(AppSizes.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'Siap Memulai Investasi Halal?',
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSizes.md),
                
                Text(
                  'Bergabunglah dengan ribuan investor yang telah merasakan keuntungan investasi syariah.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSizes.lg),
                
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xl,
                      vertical: AppSizes.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Daftar Sekarang',
                    style: AppTextStyles.buttonLarge.copyWith(
                      fontWeight: FontWeight.w700,
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

  Widget _buildHorizontalSteps() {
    return Row(
      children: [
        Expanded(child: _buildModernStep(1, 'Bergabung Koperasi', 'Menjadi anggota koperasi terdaftar untuk mengakses peluang investasi syariah.', Icons.people, '👥')),
        _buildModernStepConnector(),
        Expanded(child: _buildModernStep(2, 'Pilih Proyek', 'Jelajahi proyek bisnis yang telah diverifikasi dalam jaringan koperasi Anda.', Icons.search, '🔍')),
        _buildModernStepConnector(),
        Expanded(child: _buildModernStep(3, 'Investasi Aman', 'Lakukan investasi melalui platform aman dengan syarat yang transparan.', Icons.security, '🔒')),
        _buildModernStepConnector(),
        Expanded(child: _buildModernStep(4, 'Dapatkan Bagi Hasil', 'Terima distribusi keuntungan berdasarkan prinsip syariah Islam.', Icons.trending_up, '📈')),
      ],
    );
  }

  Widget _buildVerticalSteps() {
    return Column(
      children: [
        _buildModernStep(1, 'Bergabung Koperasi', 'Menjadi anggota koperasi terdaftar untuk mengakses peluang investasi syariah.', Icons.people, '👥'),
        _buildVerticalConnector(),
        _buildModernStep(2, 'Pilih Proyek', 'Jelajahi proyek bisnis yang telah diverifikasi dalam jaringan koperasi Anda.', Icons.search, '🔍'),
        _buildVerticalConnector(),
        _buildModernStep(3, 'Investasi Aman', 'Lakukan investasi melalui platform aman dengan syarat yang transparan.', Icons.security, '🔒'),
        _buildVerticalConnector(),
        _buildModernStep(4, 'Dapatkan Bagi Hasil', 'Terima distribusi keuntungan berdasarkan prinsip syariah Islam.', Icons.trending_up, '📈'),
      ],
    );
  }

  Widget _buildModernStep(int number, String title, String description, IconData icon, String emoji) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Modern Step Number with gradient
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Title with modern typography
          Text(
            title,
            style: AppTextStyles.h5.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Description with better spacing
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildModernStepConnector() {
    return Container(
      width: 60,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.3),
            AppColors.primary.withOpacity(0.6),
            AppColors.primary.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
  
  Widget _buildVerticalConnector() {
    return Container(
      width: 3,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: AppSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.3),
            AppColors.primary.withOpacity(0.6),
            AppColors.primary.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
