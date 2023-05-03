import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../models/faculty_model.dart';

import '../../providers/data.dart';

Future<List> facultyGetProfile({@required BuildContext context}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET',
        Uri.parse('https://result.onrender.com/faculty-detail/${data.getId}'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    int status = response.statusCode;
    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      if (res.containsKey("facultyDetail")) {
        Map obtainedFaculty = res["facultyDetail"][0];

        Faculty faculty = Faculty(
          facultyId: obtainedFaculty["facultyId"],
          name: obtainedFaculty["name"],
          dob: DateTime.parse(obtainedFaculty["DOB"]),
          doj: DateTime.parse(obtainedFaculty["DOJ"]),
          department: obtainedFaculty["department"],
          email: obtainedFaculty["email"],
          addressLine1: obtainedFaculty["addressLine1"],
          addressLine2: obtainedFaculty["addressLine2"],
          city: obtainedFaculty["city"],
          state: obtainedFaculty["state"],
          country: obtainedFaculty["country"],
          phoneNum: obtainedFaculty["phoneNum"],
        );
        return [true, faculty];
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
