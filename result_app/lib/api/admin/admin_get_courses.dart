import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../models/course_model.dart';

import '../../providers/data.dart';

Future<List> adminGetCourses(
    {@required BuildContext context, @required int currentSem}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET', Uri.parse('https://result.onrender.com/courses/sem$currentSem'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    int status = response.statusCode;
    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      if (res.containsKey("course")) {
        List<Course> courseList = [];
        List obtainedCourses = res["course"];
        for (var course in obtainedCourses) {
          courseList.add(
            Course(
              id: course["_id"],
              name: course["name"],
              semNo: course["semNo"],
              offeredBy: course["offeredBy"],
              hours: course["hours"],
              type: course["type"],
              credits: course["credits"],
              facultyId: course["facultyId"],
            ),
          );
        }
        return [true, courseList];
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
