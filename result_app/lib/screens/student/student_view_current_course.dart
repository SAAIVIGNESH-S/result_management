import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:result_app/api/student/student_get_course_detail.dart';
import 'package:result_app/api/student/student_get_current_courses.dart';
import 'package:result_app/helpers/colors.dart';
import 'package:result_app/widgets/error_display.dart';
import 'package:result_app/widgets/spinner.dart';
import 'package:result_app/widgets/student/student_app_drawer.dart';

import '../../models/course_model.dart';
import '../../providers/data.dart';

class StudentViewCurrentCourses extends StatefulWidget {
  const StudentViewCurrentCourses({Key key}) : super(key: key);

  static const routeName = '/student-view-current-courses';

  @override
  State<StudentViewCurrentCourses> createState() =>
      _StudentViewCurrentCoursesState();
}

class _StudentViewCurrentCoursesState extends State<StudentViewCurrentCourses> {
  var _isLoading = true;
  var _isSuccess = false;
  var _isCourseLoading = false;

  List _courses = [];

  @override
  void initState() {
    Data data = Provider.of<Data>(context, listen: false);
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });

      var res = await studentGetCurrentCourses(
        context: context,
        body: json.encode({
          "rollNo": data.getId,
        }),
      );
      _isSuccess = res[0];
      if (_isSuccess) {
        _courses = res[1];
      }
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
          if (_isCourseLoading)
            const CupertinoActivityIndicator(
              color: Colors.white,
              radius: 12,
            ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      drawer: const StudentAppDrawer(),
      body: _isLoading
          ? const Spinner()
          : _isSuccess
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 10 / 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                  ),
                  itemCount: _courses.length,
                  itemBuilder: (context, index) => Card(
                    child: OutlinedButton(
                      onPressed: () async {
                        setState(() {
                          _isCourseLoading = true;
                        });
                        List courseRes = await studentGetCourseDetail(
                            context: context, courseId: _courses[index]);
                        setState(() {
                          _isCourseLoading = false;
                        });
                        if (courseRes[0]) {
                          Course course = courseRes[1] as Course;
                          showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return CupertinoActionSheet(
                                title: Text(
                                  course.id,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                message: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Course Name"),
                                        Text(course.name),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Course Type"),
                                        Text(course.type),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Faculty Id"),
                                        Text(course.facultyId),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Semester"),
                                        Text(course.semNo.toString()),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Offered by"),
                                        Text(course.offeredBy),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Hours"),
                                        Text(course.hours.toString()),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Credits"),
                                        Text(course.credits.toString()),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Done"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          _courses[index],
                          style: TextStyle(color: mainColor),
                        ),
                      ),
                    ),
                  ),
                )
              : errorDisplay("Couldn't fetch courses"),
    );
  }
}
