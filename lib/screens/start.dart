import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/theme_background.dart';
import 'meditation_detail_screen.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor(context),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Text(
              'Good Morning,\nTime to Meditate',
              style: TextStyle(
                color: ThemeColors.textColor(context),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildDailyQuote(Theme.of(context).brightness == Brightness.dark),
            const SizedBox(height: 24),
            _buildRecommendedSection(Theme.of(context).brightness == Brightness.dark),
            const SizedBox(height: 24),
            _buildCategoriesSection(Theme.of(context).brightness == Brightness.dark),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  Widget _buildDailyQuote(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Quote',
            style: TextStyle(
              color: ThemeColors.secondaryTextColor(context),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"Peace comes from within. Do not seek it without."',
            style: TextStyle(
              color: ThemeColors.textColor(context),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '- Buddha',
            style: TextStyle(
              color: ThemeColors.secondaryTextColor(context),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended for You',
          style: TextStyle(
            color: ThemeColors.textColor(context),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildRecommendedCard(
                'Mindful Morning',
                '10 min',
                const Color(0xFFE6B587),
                Icons.wb_sunny_outlined,
                isDark,
              ),
              const SizedBox(width: 12),
              _buildRecommendedCard(
                'Deep Sleep',
                '20 min',
                const Color(0xFF7EB6BA),
                Icons.nightlight_outlined,
                isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard(
    String title,
    String duration,
    Color color,
    IconData icon,
    bool isDark,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeditationDetailScreen(
              title: title,
              duration: duration,
              icon: icon,
              color: color,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeColors.cardColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                color: ThemeColors.textColor(context),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              duration,
              style: TextStyle(
                color: ThemeColors.secondaryTextColor(context),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            color: ThemeColors.textColor(context),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildCategoryCard('Sleep', Icons.nightlight_round, isDark)),
            const SizedBox(width: 12),
            Expanded(child: _buildCategoryCard('Anxiety', Icons.favorite_border, isDark)),
            const SizedBox(width: 12),
            Expanded(child: _buildCategoryCard('Focus', Icons.grid_3x3, isDark)),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeditationDetailScreen(
              title: title,
              duration: '15 min',
              icon: icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: ThemeColors.cardColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: ThemeColors.textColor(context),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: ThemeColors.textColor(context),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
