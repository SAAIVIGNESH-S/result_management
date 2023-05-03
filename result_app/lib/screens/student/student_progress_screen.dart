import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:result_app/screens/student/student_sgpa_visualize_screen.dart';
import 'package:result_app/widgets/error_display.dart';

import '../../api/student/student_get_progress.dart';

import '../../helpers/colors.dart';

import '../../models/progress_model.dart';
import '../../widgets/spinner.dart';
import '../../widgets/student/student_app_drawer.dart';
import 'student_sem_visualize_screen.dart';
import 'student_sub_visualize_screen.dart';

class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({Key key}) : super(key: key);

  static const routeName = '/student-progress-screen';

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  var _isLoading = true;
  var _isSuccess = false;

  List progress;
  List<String> semOptions = ["1", "2", "3", "4", "5", "6", "7", "8"];

  int semNo;

  List<Progress> _data = [];
  List sgpa = [];
  var cgpa;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });

      var res = await studentGetProgress(context: context);
      _isSuccess = res[0];
      if (_isSuccess) {
        progress = res[1] as List;
        sgpa = res[2] as List;
        cgpa = res[3];
      }
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  void _refreshData() async {
    setState(() {
      _isLoading = true;
      semNo = null;
    });

    var res = await studentGetProgress(context: context);
    _isSuccess = res[0];
    if (_isSuccess) {
      progress = res[1] as List;
      sgpa = res[2] as List;
      cgpa = res[3];
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _getSemProgress() {
    _data = [];
    var semProgress = progress[semNo - 1]["subjectMarks"];

    for (Map subject in semProgress) {
      if (subject.containsKey("courseId")) {
        Map marks = subject["marks"];
        _data.add(
          Progress(
            courseId: subject["courseId"],
            courseType: subject["courseType"],
            cat1: marks["cat1"],
            cat2: marks["cat2"],
            assignment: marks["assignment"],
            attendance: marks["attendance"],
            lab: marks["lab"],
            sem: marks["sem"],
            grade: marks["grade"],
          ),
        );
      }
    }
  }

  Widget markDisplay(Size size, String text, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: size.width * 0.6,
        child: Text(
          "$text - $val",
          softWrap: true,
          style: TextStyle(
            color: mainColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: [
          if (_isSuccess)
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  StudentSGPAVisualizeScreen.routeName,
                  arguments: [sgpa, cgpa],
                );
              },
              icon: const Icon(Icons.remove_red_eye),
            ),
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.replay_outlined),
          ),
        ],
        backgroundColor: mainColor,
      ),
      drawer: const StudentAppDrawer(),
      body: _isLoading
          ? const Spinner()
          : _isSuccess
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        DropdownSearch<String>(
                          maxHeight: size.height * 0.3,
                          popupBarrierColor: Colors.black26,
                          mode: Mode.DIALOG,
                          dropdownSearchDecoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 61, 60, 60),
                              ),
                            ),
                          ),
                          searchBoxDecoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 61, 60, 60),
                              ),
                            ),
                          ),
                          showSearchBox: true,
                          showSelectedItem: true,
                          items: semOptions.sublist(0, sgpa.length),
                          label: "Sem No",
                          showAsSuffixIcons: true,
                          onChanged: (value) {
                            setState(() {
                              semNo = int.parse(value);
                              _getSemProgress();
                            });
                          },
                          onSaved: (newValue) {
                            setState(() {
                              semNo = int.parse(newValue);
                              _getSemProgress();
                            });
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        semNo != null
                            ? Column(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        StudentSemVisualizeScreen.routeName,
                                        arguments: [
                                          semNo,
                                          _data,
                                          sgpa[semNo - 1] ?? '',
                                        ],
                                      );
                                    },
                                    icon: const Icon(Icons.trending_up_sharp),
                                    label: const Text(
                                      'Infographics',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  for (var subject in _data)
                                    Column(
                                      children: [
                                        ExpandablePanel(
                                          header: Text(
                                            subject.courseId,
                                            style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          expanded: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  markDisplay(size, "Grade",
                                                      subject.grade),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  markDisplay(size, "CAT 1",
                                                      '${subject.cat1}'),
                                                  markDisplay(size, "CAT 2",
                                                      '${subject.cat2}'),
                                                  markDisplay(
                                                      size,
                                                      "Assignment",
                                                      '${subject.assignment}'),
                                                  markDisplay(
                                                      size,
                                                      "Attendance",
                                                      '${subject.attendance}%'),
                                                  if (subject.courseType ==
                                                      'embedded')
                                                    markDisplay(size, "Lab",
                                                        '${subject.lab}'),
                                                  markDisplay(size, "Sem",
                                                      '${subject.sem}'),
                                                ],
                                              ),
                                              SizedBox(
                                                width: size.width * 0.2,
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                        StudentSubVisualizeScreen
                                                            .routeName,
                                                        arguments: subject,
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.fast_forward,
                                                      color: mainColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          collapsed: markDisplay(
                                              size, "Grade", subject.grade),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                      ],
                                    ),
                                ],
                              )
                            : errorDisplay("Please select semester"),
                      ],
                    ),
                  ),
                )
              : errorDisplay("Couldn't fetch result"),
    );
  }
}
