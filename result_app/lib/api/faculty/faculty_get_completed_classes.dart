import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../models/enrollment_model.dart';

import '../../providers/data.dart';

Future<List> facultyGetCompletedClasses(
    {@required BuildContext context}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET', Uri.parse('https://result.onrender.com/courses/${data.getId}'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    int status = response.statusCode;
    if (status == 200) {
      List<Enrollment> classes = [];
      Map res = json.decode(await response.stream.bytesToString());
      if (res.containsKey("classes")) {
        List obtainedClasses = res["classes"];
        for (var individualClass in obtainedClasses) {
          var isCompleted = individualClass["isCompleted"];
          if (isCompleted) {
            classes.add(
              Enrollment(
                batchYear: individualClass["batchYear"],
                dept: individualClass["department"],
                courseId: individualClass["courseId"],
                courseName: individualClass["courseName"],
                courseType: individualClass["courseType"],
                facId: individualClass["facId"],
                sem: individualClass["semNo"],
                isCompleted: isCompleted,
              ),
            );
          }
        }
        return [true, classes];
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
