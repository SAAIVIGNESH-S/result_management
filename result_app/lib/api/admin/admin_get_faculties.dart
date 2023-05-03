import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../models/faculty_model.dart';

import '../../providers/data.dart';

Future<List> adminGetFaculties({@required BuildContext context}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('https://result.onrender.com/faculties'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    int status = response.statusCode;
    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      if (res.containsKey("faculty")) {
        List<Faculty> faculties = [];
        List obtainedFaculties = res["faculty"];
        for (var faculty in obtainedFaculties) {
          faculties.add(
            Faculty(
              facultyId: faculty["facultyId"],
              name: faculty["name"],
              dob: DateTime.parse(faculty["DOB"]),
              doj: DateTime.parse(faculty["DOJ"]),
              department: faculty["department"],
              email: faculty["email"],
              addressLine1: faculty["addressLine1"],
              addressLine2: faculty["addressLine2"],
              city: faculty["city"],
              state: faculty["state"],
              country: faculty["country"],
              phoneNum: faculty["phoneNum"],
            ),
          );
        }
        return [true, faculties];
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
