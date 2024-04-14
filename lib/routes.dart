import 'package:solid_app/components/home/home.dart';
import 'package:solid_app/components/login/login.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
};
