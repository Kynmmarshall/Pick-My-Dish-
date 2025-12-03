import 'package:flutter/material.dart';
import 'package:pick_my_dish/Providers/favorite_provider.dart';
import 'package:pick_my_dish/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pick_my_dish/Screens/splash_screen.dart';

void main() {
   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const PickMyDish(),
    ),
  );
}

class PickMyDish extends StatelessWidget {
  const PickMyDish({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
