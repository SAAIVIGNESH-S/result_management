import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:result_app/screens/faculty/faculty_view_current_classes_screen.dart';

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../providers/data.dart';

Future<void> facultyEnterProgress(
    {@required BuildContext context, @required body}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT', Uri.parse('https://result.onrender.com/faculty-add-result'));
    request.body = body;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    int status = response.statusCode;

    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      print(res);
      if (res.containsKey("success")) {
        await alertDialogSuccess(
            context: context,
            content: res["success"],
            option1Func: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(
                  FacultyViewCurrentClassesScreen.routeName);
            });
      } else {
        await alertDialogElse(
          context: context,
          title: "Sorry",
          content: res["message"] ?? 'An error occured',
        );
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
}
