import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:result_app/screens/student/student_view_current_course.dart';

import '../../helpers/colors.dart';
import '../../helpers/logout.dart';

import '../../providers/data.dart';

import '../../screens/common/change_password_screen.dart';
import '../../screens/student/student_home_screen.dart';
import '../../screens/student/student_profile_screen.dart';
import '../../screens/student/student_progress_screen.dart';

class StudentAppDrawer extends StatelessWidget {
  const StudentAppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data data = Provider.of<Data>(context, listen: false);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamed(StudentProfileScreen.routeName);
                },
                child: Container(
                  color: mainColor,
                  padding: EdgeInsets.only(
                    top: 24 + MediaQuery.of(context).padding.top,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 52,
                        child: Image.asset("assets/images/user.png"),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        data.getId,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Wrap(
                runSpacing: 10,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushReplacementNamed(StudentHomeScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('Progress'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(
                          StudentProgressScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.library_books),
                    title: const Text('Current Classes'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          StudentViewCurrentCourses.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_clock),
                    title: const Text('Change Password'),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(ChangePasswordScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.login_outlined),
                    title: const Text('Log out'),
                    onTap: () {
                      logout(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
