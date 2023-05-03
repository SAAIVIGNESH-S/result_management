import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:result_app/api/faculty/faculty_get_progress.dart';
import 'package:result_app/models/enrollment_model.dart';
import 'package:result_app/widgets/spinner.dart';

class FacultyViewProgressScreen extends StatefulWidget {
  const FacultyViewProgressScreen({Key key}) : super(key: key);

  static const routeName = '/faculty-view-progress-screen';

  @override
  State<FacultyViewProgressScreen> createState() =>
      _FacultyViewProgressScreenState();
}

class _FacultyViewProgressScreenState extends State<FacultyViewProgressScreen> {
  List<String> embeddedOptions = [
    "cat1",
    "cat2",
    "assignment",
    "attendance",
    "lab",
    "sem"
  ];
  List<String> theoryOptions = [
    "cat1",
    "cat2",
    "assignment",
    "attendance",
    "sem"
  ];

  var _isLoading = false;
  var _isSuccess = false;

  List _studentData = [];
  List _studentMarks = [];

  Future<void> getProgress(Enrollment enrollment) async {
    _studentData = [];
    _studentMarks = [];

    setState(() {
      _isLoading = true;
    });

    var res = await facultyGetProgress(
      context: context,
      body: json.encode({
        "batchYear": enrollment.batchYear,
        "dept": enrollment.dept,
        "sem": enrollment.sem,
        "courseId": enrollment.courseId,
        "examType": type,
      }),
    );

    _isSuccess = res[0];
    if (_isSuccess) {
      _studentData = res[1];
      _studentMarks = res[2];
    }

    setState(() {
      _isLoading = false;
    });
  }

  String type;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Enrollment enrollment =
        ModalRoute.of(context).settings.arguments as Enrollment;

    return Scaffold(
      appBar: AppBar(
        title: const Text("View Progress"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownSearch<String>(
              maxHeight: size.height * 0.4,
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
              items: enrollment.courseType == 'embedded'
                  ? embeddedOptions
                  : theoryOptions,
              label: "Type",
              showAsSuffixIcons: true,
              onChanged: (value) {
                setState(() {
                  type = value;
                  getProgress(enrollment);
                });
              },
              onSaved: (newValue) {
                setState(() {
                  type = newValue;
                  getProgress(enrollment);
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
            _isLoading
                ? const Spinner()
                : SizedBox(
                    height: size.height * 0.7,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 10 / 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 15,
                      ),
                      itemCount: _studentData.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 5,
                        child: Center(
                          child: Text(
                            '${_studentData[index]} - ${_studentMarks[index]}',
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
