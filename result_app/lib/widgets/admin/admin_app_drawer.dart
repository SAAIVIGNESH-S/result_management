import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:result_app/helpers/logout.dart';
import 'package:result_app/screens/admin/admin_profile_screen.dart';
import 'package:result_app/screens/admin/admin_restrict_screen.dart';
import 'package:result_app/screens/common/change_password_screen.dart';

import '../../helpers/colors.dart';

import '../../providers/data.dart';

import '../../screens/admin/admin_add_course_screen.dart';
import '../../screens/admin/admin_add_faculty_screen.dart';
import '../../screens/admin/admin_home_screen.dart';
import '../../screens/admin/admin_view_faculties_screen.dart';
import '../../screens/admin/admin_add_student_screen.dart';
import '../../screens/admin/admin_view_batches_screen.dart';

class AdminAppDrawer extends StatelessWidget {
  const AdminAppDrawer({Key key}) : super(key: key);

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
                  Navigator.of(context).pushNamed(AdminProfileScreen.routeName);
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
                        style:
                            const TextStyle(fontSize: 28, color: Colors.white),
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
                          .pushReplacementNamed(AdminHomeScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.health_and_safety_rounded),
                    title: const Text('Add Faculty'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          AdminAddFacultyScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_comment_rounded),
                    title: const Text('Add Student'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          AdminAddStudentScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.book_outlined),
                    title: const Text('Add Course'),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AdminAddCourseScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.view_agenda_outlined),
                    title: const Text('View Faculties'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          AdminViewFacultiesScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.data_array),
                    title: const Text('View Batches'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          AdminViewBatchesScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Restrictions'),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AdminRestrictScreen.routeName);
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
