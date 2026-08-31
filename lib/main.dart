import 'package:bmi_project/bottomNav/bottom_nav.dart';
import 'package:bmi_project/screens/auth_pages/forgot_password_screen.dart';
import 'package:bmi_project/screens/auth_pages/login_screen.dart';
import 'package:bmi_project/screens/auth_pages/sign_up_screen.dart';
import 'package:bmi_project/screens/dashboard_screen.dart';
import 'package:bmi_project/screens/profile_screen.dart';
import 'package:bmi_project/screens/user_detail_pages/details_screen.dart';
import 'package:bmi_project/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_state_manger.dart';
import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notificationService = NotificationService();
  await notificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      title: 'BMI Tracker',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),

        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/bottom-nav': (context) => const BottomNav(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/details': (context) => const UserDetailsScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/settings': (context) => const ProfileScreen(),
      },
    );
  }
}
