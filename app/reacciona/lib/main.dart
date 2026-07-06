import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const LedTrainerApp());
}

class LedTrainerApp extends StatelessWidget {
  const LedTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LED Trainer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}