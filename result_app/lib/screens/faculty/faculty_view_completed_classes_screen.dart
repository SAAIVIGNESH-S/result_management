import 'package:flutter/material.dart';
import 'package:result_app/helpers/colors.dart';

import '../../api/faculty/faculty_get_completed_classes.dart';

import '../../models/enrollment_model.dart';

import '../../widgets/faculty/faculty_app_drawer.dart';
import '../../widgets/spinner.dart';
import '../../widgets/error_display.dart';
import 'faculty_view_progress_screen.dart';
import 'faculty_view_students_screen.dart';

class FacultyViewCompletedClassesScreen extends StatefulWidget {
  const FacultyViewCompletedClassesScreen({Key key}) : super(key: key);

  static const routeName = 'faculty-view-completed-classes-screen';

  @override
  State<FacultyViewCompletedClassesScreen> createState() =>
      _FacultyViewCompletedClassesScreenState();
}

class _FacultyViewCompletedClassesScreenState
    extends State<FacultyViewCompletedClassesScreen> {
  var _isLoading = true;
  var _isSuccess = false;

  List<Enrollment> _data = [];

  Future<void> _fetchClasses() async {
    _data = [];

    setState(() {
      _isLoading = true;
    });

    var res = await facultyGetCompletedClasses(context: context);
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
        title: const Text("Completed Classes"),
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
                  ? errorDisplay("No Completed Courses")
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
                                          individualClass.sem.toString(),
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
                                                      child: Row(
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
