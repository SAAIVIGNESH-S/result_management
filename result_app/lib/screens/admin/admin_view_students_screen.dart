import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:result_app/helpers/colors.dart';

import '../../api/admin/admin_get_student_detail.dart';

import '../../api/admin/admin_promote_batch.dart';
import '../../models/batch_model.dart';
import '../../models/student_model.dart';

class AdminViewStudentsScreen extends StatefulWidget {
  const AdminViewStudentsScreen({Key key}) : super(key: key);

  static const routeName = '/admin-view-students-screen';

  @override
  State<AdminViewStudentsScreen> createState() =>
      _AdminViewStudentsScreenState();
}

class _AdminViewStudentsScreenState extends State<AdminViewStudentsScreen> {
  var _isLoading = false;
  var _isSuccess = false;

  Student _data;

  Future<bool> _fetchStudentDetails(String rollNum) async {
    setState(() {
      _isLoading = true;
    });

    var res = await adminGetStudentDetail(context: context, rollNum: rollNum);
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
  Widget build(BuildContext context) {
    Batch batch = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("${batch.batchYear} ${batch.dept} Students"),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await adminPromoteBatch(
                context: context,
                body: json
                    .encode({"batchYear": batch.batchYear, "dept": batch.dept}),
              );
              setState(() {
                _isLoading = false;
              });
            },
            child: const Text(
              "Promote",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
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
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 10 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 15,
        ),
        itemCount: batch.students.length,
        itemBuilder: (context, index) => Card(
          child: OutlinedButton(
            onPressed: () async {
              if (await _fetchStudentDetails(batch.students[index])) {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return CupertinoActionSheet(
                      title: Text(
                        batch.students[index],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
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
                batch.students[index],
                style: TextStyle(color: mainColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
