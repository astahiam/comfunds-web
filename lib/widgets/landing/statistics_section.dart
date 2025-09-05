import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xl,
        vertical: AppSizes.xxl * 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          // HAJIFUND Section Header
          Text(
            'Dipercaya Ribuan Pendana & Peminjam',
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Platform P2P lending syariah terdepan di Indonesia dengan tingkat keberhasilan tinggi dan return yang kompetitif sesuai prinsip syariah.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withOpacity(0.9),
                height: 1.6,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: AppSizes.xxl),
          
          // Statistics Grid
          LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth > 768 
                ? Row(
                    children: [
                      Expanded(child: _buildStatCard('50.000+', 'Pendana Aktif', Icons.people, '👥')),
                      const SizedBox(width: AppSizes.xl),
                      Expanded(child: _buildStatCard('Rp 500M+', 'Dana Tersalurkan', Icons.account_balance_wallet, '💰')),
                      const SizedBox(width: AppSizes.xl),
                      Expanded(child: _buildStatCard('98.5%', 'Tingkat Keberhasilan', Icons.business_center, '📊')),
                      const SizedBox(width: AppSizes.xl),
                      Expanded(child: _buildStatCard('18%', 'Return Per Tahun', Icons.trending_up, '📈')),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildStatCard('50.000+', 'Pendana Aktif', Icons.people, '👥')),
                          const SizedBox(width: AppSizes.lg),
                          Expanded(child: _buildStatCard('Rp 500M+', 'Dana Tersalurkan', Icons.account_balance_wallet, '💰')),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),
                      Row(
                        children: [
                          Expanded(child: _buildStatCard('98.5%', 'Tingkat Keberhasilan', Icons.business_center, '📊')),
                          const SizedBox(width: AppSizes.lg),
                          Expanded(child: _buildStatCard('18%', 'Return Per Tahun', Icons.trending_up, '📈')),
                        ],
                      ),
                    ],
                  );
            },
          ),
          
          const SizedBox(height: AppSizes.xxl),
          
          // Trust Badges
          Container(
            padding: const EdgeInsets.all(AppSizes.xl),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Sertifikasi & Penghargaan',
                  style: AppTextStyles.h5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                
                const SizedBox(height: AppSizes.lg),
                
                Wrap(
                  spacing: AppSizes.xl,
                  runSpacing: AppSizes.lg,
                  children: [
                    _buildTrustBadge('🏆', 'P2P Lending Terbaik 2024'),
                    _buildTrustBadge('🛡️', 'Terdaftar OJK'),
                    _buildTrustBadge('🕌', 'Tersertifikasi DSN-MUI'),
                    _buildTrustBadge('⭐', 'Rating 4.8/5'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, String emoji) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Emoji and Icon
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: Colors.white.withOpacity(0.7),
                  size: 30,
                ),
              ),
              Positioned(
                top: -5,
                right: -5,
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Value
          Text(
            value,
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 28,
            ),
          ),
          
          const SizedBox(height: AppSizes.sm),
          
          // Label
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
