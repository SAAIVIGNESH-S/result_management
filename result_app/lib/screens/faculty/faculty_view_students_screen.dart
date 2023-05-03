import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../api/faculty/faculty_get_students.dart';
import '../../api/faculty/faculty_get_student_detail.dart';

import '../../helpers/colors.dart';
import '../../models/enrollment_model.dart';
import '../../models/student_model.dart';

import '../../widgets/error_display.dart';
import '../../widgets/spinner.dart';

class FacultyViewStudentsScreen extends StatefulWidget {
  const FacultyViewStudentsScreen({Key key}) : super(key: key);

  static const routeName = '/faculty-view-students-screen';

  @override
  State<FacultyViewStudentsScreen> createState() =>
      _AdminViewStudentsScreenState();
}

class _AdminViewStudentsScreenState extends State<FacultyViewStudentsScreen> {
  var _isLoading = false;
  var _isSuccess = false;
  var _isStudentLoading = true;
  var _isStudentSuccess = false;

  Student _data;

  List _students = [];

  Future<void> _fetchStudents(String batchYear, String department) async {
    setState(() {
      _isStudentLoading = true;
    });

    var res = await facultyGetStudents(
      context: context,
      body: json.encode({"batchYear": batchYear, "department": department}),
    );
    _isStudentSuccess = res[0];
    if (_isStudentSuccess) {
      _students = res[1] as List;
    }

    setState(() {
      _isStudentLoading = false;
    });
  }

  Future<bool> _fetchStudentDetails(String rollNum) async {
    setState(() {
      _isLoading = true;
    });

    var res = await facultyGetStudentDetail(context: context, rollNum: rollNum);
    _isSuccess = res[0];
    if (_isSuccess) {
      _data = res[1] as Student;
    }

    setState(() {
      _isLoading = false;
    });

    return _isSuccess;
  }

  Widget _displayDetails() {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 100,
          child: Image.asset("assets/images/user.png"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Adm No"),
            Text(_data.admissionNo),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Name"),
            Text(_data.name),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Email"),
            Text(_data.email),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Batch - Dept"),
            Text("${_data.batchYear} - ${_data.department}"),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("DOB"),
            Text(
              DateFormat('dd/MM/yyyy').format(_data.dob),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Phone"),
            Text(_data.phoneNum),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Parent Name"),
            Text(_data.parentName),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Parent Phone"),
            Text(_data.parentPhoneNum),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Text("Address"),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity - 40,
          child: Center(
            child: Text(
              "${_data.addressLine1}, ${_data.addressLine2}, ${_data.city}, ${_data.state}",
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      Enrollment enrollment = ModalRoute.of(context).settings.arguments;
      setState(() {
        _isStudentLoading = true;
      });
      await _fetchStudents(enrollment.batchYear, enrollment.dept);
      setState(() {
        _isStudentLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Enrollment enrollment = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("${enrollment.batchYear} ${enrollment.dept} Students"),
        actions: [
          if (_isLoading)
            const CupertinoActivityIndicator(
              color: Colors.white,
              radius: 12,
            ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: _isStudentLoading
          ? const Spinner()
          : _isStudentSuccess
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 10 / 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                  ),
                  itemCount: _students.length,
                  itemBuilder: (context, index) => Card(
                    child: OutlinedButton(
                      onPressed: () async {
                        if (await _fetchStudentDetails(_students[index])) {
                          showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return CupertinoActionSheet(
                                title: Text(
                                  _students[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                message: _displayDetails(),
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
                          _students[index],
                          style: TextStyle(color: mainColor),
                        ),
                      ),
                    ),
                  ),
                )
              : errorDisplay("Couldn't fetch students"),
    );
  }
}
