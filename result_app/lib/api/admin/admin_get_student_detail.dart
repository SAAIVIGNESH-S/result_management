import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../models/student_model.dart';

import '../../providers/data.dart';

Future<List> adminGetStudentDetail(
    {@required BuildContext context, @required String rollNum}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET',
        Uri.parse('https://result.onrender.com/student-detail/$rollNum'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    int status = response.statusCode;
    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());

      if (res.containsKey("studentDetail")) {
        var obtainedDetails = res["studentDetail"][0];
        Student student = Student(
          rollNo: obtainedDetails["rollNo"],
          name: obtainedDetails["name"],
          admissionNo: obtainedDetails["admissionNo"],
          dob: DateTime.parse(obtainedDetails["DOB"]),
          department: obtainedDetails["department"],
          email: obtainedDetails["email"],
          batchYear: obtainedDetails["batchYear"].toString(),
          addressLine1: obtainedDetails["addressLine1"],
          addressLine2: obtainedDetails["addressLine2"],
          city: obtainedDetails["city"],
          state: obtainedDetails["state"],
          country: obtainedDetails["country"],
          phoneNum: obtainedDetails["phoneNum"],
          parentName: obtainedDetails["parentName"],
          parentPhoneNum: obtainedDetails["parentNum"],
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
