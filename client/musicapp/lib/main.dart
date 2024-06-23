import 'package:flutter/material.dart';
import 'package:musicapp/core/theme/theme.dart';
import 'package:musicapp/features/auth/view/pages/login_page.dart';
import 'package:musicapp/features/auth/view/pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}
