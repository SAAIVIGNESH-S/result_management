import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:result_app/screens/admin/admin_restrict_screen.dart';
import 'package:result_app/screens/student/student_view_current_course.dart';

import './screens/common/splash_screen.dart';
import './screens/common/auth_screen.dart';
import './screens/common/forgot_password_screen.dart';
import './screens/common/change_password_screen.dart';

import './screens/admin/admin_home_screen.dart';
import './screens/admin/admin_profile_screen.dart';
import './screens/admin/admin_add_faculty_screen.dart';
import './screens/admin/admin_view_faculties_screen.dart';
import './screens/admin/admin_view_faculty_detail_screen.dart';
import './screens/admin/admin_view_batches_screen.dart';
import './screens/admin/admin_add_student_screen.dart';
import './screens/admin/admin_add_course_screen.dart';
import './screens/admin/admin_enrollment_screen.dart';
import './screens/admin/admin_view_students_screen.dart';

import './screens/faculty/faculty_home_screen.dart';
import './screens/faculty/faculty_view_completed_classes_screen.dart';
import './screens/faculty/faculty_view_current_classes_screen.dart';
import './screens/faculty/faculty_view_students_screen.dart';

import './screens/student/student_home_screen.dart';
import './screens/faculty/faculty_enter_progress_screen.dart';
import './screens/faculty/faculty_profile_screen.dart';
import './screens/student/student_profile_screen.dart';
import './screens/student/student_progress_screen.dart';
import 'screens/faculty/faculty_view_progress_screen.dart';
import 'screens/student/student_sem_visualize_screen.dart';
import 'screens/student/student_sgpa_visualize_screen.dart';
import 'screens/student/student_sub_visualize_screen.dart';

import './helpers/colors.dart';

import './providers/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Data()),
      ],
      child: MaterialApp(
        title: 'Result',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: mainColor,
          ),
          disabledColor: Colors.grey,
          primaryColor: mainColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: mainColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF1E6FF),
            iconColor: mainColor,
            prefixIconColor: mainColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          AuthScreen.routeName: (_) => const AuthScreen(),
          ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
          ChangePasswordScreen.routeName: (_) => const ChangePasswordScreen(),
          AdminHomeScreen.routeName: (_) => const AdminHomeScreen(),
          AdminProfileScreen.routeName: (_) => const AdminProfileScreen(),
          AdminAddFacultyScreen.routeName: (_) => const AdminAddFacultyScreen(),
          AdminAddStudentScreen.routeName: (_) => const AdminAddStudentScreen(),
          AdminAddCourseScreen.routeName: (_) => const AdminAddCourseScreen(),
          AdminViewFacultiesScreen.routeName: (_) =>
              const AdminViewFacultiesScreen(),
          AdminViewStudentsScreen.routeName: (_) =>
              const AdminViewStudentsScreen(),
          AdminViewFacultyDetailScreen.routeName: (_) =>
              const AdminViewFacultyDetailScreen(),
          AdminViewBatchesScreen.routeName: (_) =>
              const AdminViewBatchesScreen(),
          AdminEnrollmentScreen.routeName: (_) => const AdminEnrollmentScreen(),
          AdminRestrictScreen.routeName: (_) => const AdminRestrictScreen(),
          FacultyHomeScreen.routeName: (_) => const FacultyHomeScreen(),
          FacultyProfileScreen.routeName: (_) => const FacultyProfileScreen(),
          FacultyViewCurrentClassesScreen.routeName: (_) =>
              const FacultyViewCurrentClassesScreen(),
          FacultyViewCompletedClassesScreen.routeName: (_) =>
              const FacultyViewCompletedClassesScreen(),
          FacultyViewStudentsScreen.routeName: (_) =>
              const FacultyViewStudentsScreen(),
          FacultyEnterProgressScreen.routeName: (_) =>
              const FacultyEnterProgressScreen(),
          FacultyViewProgressScreen.routeName: (_) =>
              const FacultyViewProgressScreen(),
          StudentHomeScreen.routeName: (_) => const StudentHomeScreen(),
          StudentProfileScreen.routeName: (_) => const StudentProfileScreen(),
          StudentViewCurrentCourses.routeName: (_) =>
              const StudentViewCurrentCourses(),
          StudentProgressScreen.routeName: (_) => const StudentProgressScreen(),
          StudentSGPAVisualizeScreen.routeName: (_) =>
              const StudentSGPAVisualizeScreen(),
          StudentSubVisualizeScreen.routeName: (_) =>
              const StudentSubVisualizeScreen(),
          StudentSemVisualizeScreen.routeName: (_) =>
              const StudentSemVisualizeScreen(),
        },
      ),
    );
  }
}
