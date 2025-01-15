import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';
import '../screens/start.dart';
import '../screens/favorites_screen.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  
  const BottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            Icons.home,
            currentIndex == 0,
            () => _navigateToPage(context, 0),
          ),
          _buildNavItem(
            context,
            Icons.search,
            currentIndex == 1,
            () => _navigateToPage(context, 1),
          ),
          _buildNavItem(
            context,
            Icons.favorite_border,
            currentIndex == 2,
            () => _navigateToPage(context, 2),
          ),
          _buildNavItem(
            context,
            Icons.person_outline,
            currentIndex == 3,
            () => _navigateToPage(context, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white38,
        size: 28,
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        );
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesScreen()),
        );
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
    }
  }
} 