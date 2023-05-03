import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_item/multi_select_item.dart';

import '../../api/admin/admin_add_enrollment.dart';
import '../../api/admin/admin_get_courses.dart';

import '../../models/batch_model.dart';
import '../../models/course_model.dart';

import '../../widgets/error_display.dart';
import '../../widgets/spinner.dart';

class AdminEnrollmentScreen extends StatefulWidget {
  const AdminEnrollmentScreen({Key key}) : super(key: key);

  static const routeName = '/admin-enrollment-screen';

  @override
  State<AdminEnrollmentScreen> createState() => _AdminEnrollmentScreenState();
}

class _AdminEnrollmentScreenState extends State<AdminEnrollmentScreen> {
  var _isLoading = true;
  var _isSuccess = false;

  MultiSelectController controller = MultiSelectController();
  List<Course> _courseList = [];

  Future<void> _fetchCourses(int currentSem) async {
    setState(() {
      _isLoading = true;
    });

    var res = await adminGetCourses(context: context, currentSem: currentSem);
    _isSuccess = res[0];
    if (_isSuccess) {
      _courseList = res[1] as List<Course>;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _enrollCourses(
      String dept, String batchYear, int currentSem) async {
    setState(() {
      _isLoading = true;
    });

    var selectedCoursesId = [];
    var selectedFaculties = [];
    var selectedCoursesName = [];
    var selectedCoursesType = [];
    for (var index in controller.selectedIndexes) {
      selectedCoursesId.add(_courseList[index].id);
      selectedFaculties.add(_courseList[index].facultyId);
      selectedCoursesName.add(_courseList[index].name);
      selectedCoursesType.add(_courseList[index].type);
    }
    print(selectedFaculties);

    await adminAddEnrollment(
      context: context,
      body: json.encode({
        "department": dept,
        "batchYear": batchYear,
        "courseId": selectedCoursesId,
        "courseName": selectedCoursesName,
        "courseType": selectedCoursesType,
        "faculties": selectedFaculties,
        "currentSem": currentSem,
      }),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      Batch batch = ModalRoute.of(context).settings.arguments;
      setState(() {
        _isLoading = true;
      });
      await _fetchCourses(batch.currentSem);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  Widget _displayDetails(List currentCourses) {
    return Column(
      children: [
        if (currentCourses.isEmpty)
          errorDisplay("No Courses Enrolled Yet")
        else
          for (var course in currentCourses)
            Column(
              children: [
                Text(course.toString()),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Batch batch = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${batch.batchYear} ${batch.dept} Courses",
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return CupertinoActionSheet(
                    title: const Text(
                      "Current Courses",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    message: _displayDetails(batch.currentCourses),
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
            },
            icon: const Icon(Icons.remove_red_eye),
            iconSize: 20,
          ),
          if (_isSuccess)
            TextButton(
              onPressed: () async {
                await _enrollCourses(
                    batch.dept, batch.batchYear, batch.currentSem);
              },
              child: const Text(
                "Enroll",
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Spinner()
          : _isSuccess
              ? ListView.builder(
                  itemCount: _courseList.length,
                  itemBuilder: (context, index) {
                    return MultiSelectItem(
                      isSelecting: controller.isSelecting,
                      onSelected: () {
                        setState(() {
                          controller.toggle(index);
                        });
                      },
                      child: Container(
                        decoration: controller.isSelected(index)
                            ? BoxDecoration(color: Colors.grey[300])
                            : const BoxDecoration(),
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text("Credits"),
                              Text(_courseList[index].credits.toString()),
                            ],
                          ),
                          title: Text(_courseList[index].id),
                          subtitle: Text(_courseList[index].name),
                          trailing: Text("${_courseList[index].hours} hours"),
                        ),
                      ),
                    );
                  },
                )
              : errorDisplay("An error occured"),
    );
  }
}
