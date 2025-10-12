import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WorkcycleApp());
}

class WorkcycleApp extends StatelessWidget {
  const WorkcycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '교대근무 달력',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'NotoSansKR',
      ),
      home: const HomeScreen(),
    );
  }
}
