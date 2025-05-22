import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_shop/core/presentation/first_screen_model.dart';
import 'package:test_shop/features/shop_feature/presentation/shop_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool('is_first_launch') ?? true;
    if (isFirst) {
      await prefs.setBool('is_first_launch', false);
    }
    return isFirst;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isFirstLaunch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final isFirst = snapshot.data ?? false;

        if (!isFirst) {
          return const ShopScreen();
        }

        return FirstScreenModel(
          path: 'assets/first_screen/green.png',
          nextScreen: FirstScreenModel(
            path: 'assets/first_screen/church.png',
            nextScreen: const ShopScreen(),
          ),
        );
      },
    );
  }
}
