import 'package:flutter/material.dart';
import 'locations_screen.dart';
import 'theme.dart';

void main() {
  runApp(const LagawApp());
}

class LagawApp extends StatelessWidget {
  const LagawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lagaw Bacolod',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LocationsScreen(),
    );
  }
}
