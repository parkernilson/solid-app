import 'package:flutter/material.dart';
import 'package:solid_app/theme.dart';
import 'package:solid_app/routes.dart';
import 'package:solid_app/components/home/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      home: const HomeScreen(),
      routes: appRoutes,
    );
  }
}