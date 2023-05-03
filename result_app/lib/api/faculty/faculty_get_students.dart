import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/call_alert_dialog.dart';
import '../../helpers/colors.dart';
import '../../helpers/logout.dart';

import '../../providers/data.dart';

Future<List> facultyGetStudents(
    {@required BuildContext context, @required body}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('https://result.onrender.com/students'));

    request.body = body;
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    int status = response.statusCode;
    if (status == 200) {
      List students = [];
      Map res = json.decode(await response.stream.bytesToString());
      if (res.containsKey("students")) {
        students = res["students"];
        students.sort();
      }
      return [true, students];
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
