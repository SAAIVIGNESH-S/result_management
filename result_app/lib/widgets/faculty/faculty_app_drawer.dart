import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/colors.dart';
import '../../helpers/logout.dart';

import '../../providers/data.dart';
import '../../screens/common/change_password_screen.dart';
import '../../screens/faculty/faculty_home_screen.dart';
import '../../screens/faculty/faculty_profile_screen.dart';
import '../../screens/faculty/faculty_view_completed_classes_screen.dart';
import '../../screens/faculty/faculty_view_current_classes_screen.dart';

class FacultyAppDrawer extends StatelessWidget {
  const FacultyAppDrawer({Key key}) : super(key: key);

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
                      .pushNamed(FacultyProfileScreen.routeName);
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
                          .pushReplacementNamed(FacultyHomeScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.book),
                    title: const Text('Current Classes'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          FacultyViewCurrentClassesScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.done_all_outlined),
                    title: const Text('Completed Classes'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          FacultyViewCompletedClassesScreen.routeName);
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
