import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../models/student_model.dart';

import '../../providers/data.dart';

Future<List> studentGetProfile({@required BuildContext context}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET',
        Uri.parse('https://result.onrender.com/student-detail/${data.getId}'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    int status = response.statusCode;
    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      print(res);
      if (res.containsKey("studentDetail")) {
        Map obtainedStudent = res["studentDetail"][0];

        Student student = Student(
          rollNo: obtainedStudent["rollNo"],
          name: obtainedStudent["name"],
          admissionNo: obtainedStudent["admissionNo"],
          dob: DateTime.parse(obtainedStudent["DOB"]),
          department: obtainedStudent["department"],
          email: obtainedStudent["email"],
          batchYear: obtainedStudent["batchYear"],
          addressLine1: obtainedStudent["addressLine1"],
          addressLine2: obtainedStudent["addressLine2"],
          city: obtainedStudent["city"],
          state: obtainedStudent["state"],
          country: obtainedStudent["country"],
          phoneNum: obtainedStudent["phoneNum"],
          parentName: obtainedStudent["parentName"],
          parentPhoneNum: obtainedStudent["parentNum"],
        );
        return [true, student];
      }
    } else if (status == 401) {
      await alertDialogSingleOption(
        context: context,
        title: "Session Expired",
        content: "Please login again",
        option1: "Login Again",
        option1Color: mainColor,
        option1Func: () {
          logout(context);
        },
      );
    } else {
      await alertDialogElse(
        context: context,
        title: "Sorry",
        content: "Please try again",
      );
    }
  } catch (error) {
    await alertDialogError(context: context);
  }

  return [false, []];
}
