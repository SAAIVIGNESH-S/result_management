import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';

import '../student/student_home_screen.dart';
import '../faculty/faculty_home_screen.dart';
import '../admin/admin_home_screen.dart';

import '../../providers/data.dart';

import './auth_screen.dart';
import './waiting_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data data = Provider.of(context, listen: false);
    return AnimatedSplashScreen(
      duration: 1500,
      splash: Image.asset(
        "assets/images/splash.png",
        fit: BoxFit.contain,
      ),
      nextScreen: FutureBuilder(
        future: data.tryAutoLogin(context),
        builder: (ctx, userDataSnapshot) =>
            userDataSnapshot.connectionState == ConnectionState.waiting
                ? const WaitingScreen()
                : data.getEmail == null ||
                        data.getAccessToken == null ||
                        data.getRole == null ||
                        data.getId == null ||
                        data.getIsLoggedIn == null ||
                        data.getLoginType == null
                    ? const AuthScreen()
                    : data.getIsLoggedIn
                        ? data.getRole == 'student'
                            ? const StudentHomeScreen()
                            : data.getRole == 'faculty'
                                ? const FacultyHomeScreen()
                                : data.getRole == 'admin'
                                    ? const AdminHomeScreen()
                                    : const AuthScreen()
                        : const AuthScreen(),
      ),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}
