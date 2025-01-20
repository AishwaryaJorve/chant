import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin AuthRequiredMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userId = prefs.getInt('userId');

    if (!isLoggedIn || userId == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/welcome');
      }
    }
  }
} 