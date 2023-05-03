import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../models/course_model.dart';
import '../../providers/data.dart';

Future<List> studentGetCourseDetail(
    {@required BuildContext context, @required courseId}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET', Uri.parse('https://result.onrender.com/course/$courseId'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    int status = response.statusCode;
    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());

      if (res.containsKey("course")) {
        Map obtainedCourse = res["course"];
        Course course = Course(
          id: obtainedCourse["_id"],
          name: obtainedCourse["name"],
          semNo: obtainedCourse["semNo"],
          offeredBy: obtainedCourse["offeredBy"],
          hours: obtainedCourse["hours"],
          type: obtainedCourse["type"],
          credits: obtainedCourse["credits"],
          facultyId: obtainedCourse["facultyId"],
        );

        return [true, course];
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
