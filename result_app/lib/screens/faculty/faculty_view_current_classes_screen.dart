import 'package:flutter/material.dart';
import 'package:result_app/screens/faculty/faculty_enter_progress_screen.dart';

import '../../api/faculty/faculty_get_current_classes.dart';

import '../../helpers/colors.dart';
import '../../models/enrollment_model.dart';

import '../../widgets/faculty/faculty_app_drawer.dart';
import '../../widgets/spinner.dart';
import '../../widgets/error_display.dart';

import './faculty_view_students_screen.dart';
import 'faculty_view_progress_screen.dart';

class FacultyViewCurrentClassesScreen extends StatefulWidget {
  const FacultyViewCurrentClassesScreen({Key key}) : super(key: key);

  static const routeName = '/faculty-view-current-classes-screen';

  @override
  State<FacultyViewCurrentClassesScreen> createState() =>
      _FacultyViewCurrentClassesScreenState();
}

class _FacultyViewCurrentClassesScreenState
    extends State<FacultyViewCurrentClassesScreen> {
  var _isLoading = true;
  var _isSuccess = false;

  List<Enrollment> _data = [];

  Future<void> _fetchClasses() async {
    _data = [];

    setState(() {
      _isLoading = true;
    });

    var res = await facultyGetCurrentClasses(context: context);
    _isSuccess = res[0];
    if (_isSuccess) {
      _data = res[1] as List<Enrollment>;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await _fetchClasses();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Classes"),
        actions: [
          IconButton(
            onPressed: _fetchClasses,
            icon: const Icon(Icons.replay_outlined),
          ),
        ],
      ),
      drawer: const FacultyAppDrawer(),
      body: _isLoading
          ? const Spinner()
          : _isSuccess
              ? _data.isEmpty
                  ? errorDisplay("No Current Classes")
                  : ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        final individualClass = _data[index];

                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(individualClass.batchYear),
                                        Text(individualClass.dept),
                                      ],
                                    ),
                                    title: Column(
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Semester ${individualClass.sem}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Text(individualClass.courseId),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(individualClass.courseName),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: const [
                                        Icon(Icons.arrow_forward_sharp),
                                      ],
                                    ),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Text(
                                                      "Select an option",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Divider(
                                                      thickness: 0.5,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                FacultyEnterProgressScreen
                                                                    .routeName,
                                                                arguments:
                                                                    individualClass,
                                                              );
                                                            },
                                                            child: Text(
                                                              "Enter progress",
                                                              style: TextStyle(
                                                                color:
                                                                    mainColor,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                FacultyViewProgressScreen
                                                                    .routeName,
                                                                arguments:
                                                                    individualClass,
                                                              );
                                                            },
                                                            child: Text(
                                                              "View progress",
                                                              style: TextStyle(
                                                                color:
                                                                    mainColor,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                FacultyViewStudentsScreen
                                                                    .routeName,
                                                                arguments:
                                                                    individualClass,
                                                              );
                                                            },
                                                            child: Text(
                                                              "View Students",
                                                              style: TextStyle(
                                                                color:
                                                                    mainColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
              : errorDisplay("An error occured"),
    );
  }
}
