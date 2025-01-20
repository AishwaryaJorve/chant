import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/theme_background.dart';
import 'meditation_detail_screen.dart';
import '../data/daily_quotes.dart';
import '../mixins/auth_required_mixin.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with AuthRequiredMixin {
  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor(context),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Text(
              '$greeting,\nTime to Meditate',
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
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        totalMalas: 0,
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Widget _buildDailyQuote(bool isDark) {
    final todayQuote = DailyQuotes.getQuoteOfDay();
    
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
            '"${todayQuote.quote}"',
            style: TextStyle(
              color: ThemeColors.textColor(context),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '- ${todayQuote.author}',
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
                '1 min',
                Colors.orange,
                Icons.wb_sunny_outlined,
                isDark,
              ),
              const SizedBox(width: 12),
              _buildRecommendedCard(
                'Deep Sleep',
                '20 min',
                Colors.indigo,
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
    final categories = [
      {
        'title': 'Sleep',
        'icon': Icons.nightlight_outlined,
        'color': Colors.indigo,
      },
      {
        'title': 'Anxiety',
        'icon': Icons.healing_outlined,
        'color': Colors.teal,
      },
      {
        'title': 'Focus',
        'icon': Icons.lens_outlined,
        'color': Colors.orange,
      },
    ];

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
          children: categories.map((category) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: category == categories.last ? 0 : 12,
                ),
                child: _buildCategoryCard(
                  category['title'] as String,
                  category['icon'] as IconData,
                  category['color'] as Color,
                  isDark,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeditationDetailScreen(
              title: title,
              duration: '15 min',
              icon: icon,
              color: color,
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 38,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
