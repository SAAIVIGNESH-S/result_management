import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../helpers/call_alert_dialog.dart';
import '../../helpers/colors.dart';
import '../../helpers/logout.dart';

import '../../providers/data.dart';

import '../../screens/student/student_home_screen.dart';
import '../../screens/faculty/faculty_home_screen.dart';
import '../../screens/admin/admin_home_screen.dart';

Future<void> getToken({
  @required BuildContext context,
  @required String email,
  @required String password,
}) async {
  Data data = Provider.of<Data>(context, listen: false);
  try {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'GET',
      Uri.parse('https://result.onrender.com/login-user'),
    );
    request.body = json.encode({
      "email": email,
      "password": password,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    int status = response.statusCode;

    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      if (res.containsKey("accessToken") && res.containsKey("rollNo")) {
        data.updateData(
          obtainedEmail: email,
          obtainedAccessToken: res["accessToken"],
          obtainedId: res["rollNo"],
          obtainedRole: "student",
          obtainedLoggedIn: true,
          obtainedType: "email",
        );

        Navigator.of(context).pushReplacementNamed(StudentHomeScreen.routeName);
      } else if (res.containsKey("accessToken") &&
          res.containsKey("facultyId")) {
        data.updateData(
          obtainedEmail: email,
          obtainedAccessToken: res["accessToken"],
          obtainedId: res["facultyId"],
          obtainedRole: "faculty",
          obtainedLoggedIn: true,
          obtainedType: "email",
        );

        Navigator.of(context).pushReplacementNamed(FacultyHomeScreen.routeName);
      } else if (res.containsKey("accessToken") && res.containsKey("adminId")) {
        data.updateData(
          obtainedEmail: email,
          obtainedAccessToken: res["accessToken"],
          obtainedId: res["adminId"],
          obtainedRole: "admin",
          obtainedLoggedIn: true,
          obtainedType: "email",
        );

        Navigator.of(context).pushReplacementNamed(AdminHomeScreen.routeName);
      } else if (res.containsKey("message")) {
        await alertDialogSingleOption(
          context: context,
          title: "Sorry",
          content: res["message"],
          option1: "Try again",
          option1Color: mainColor,
          option1Func: () => logout(context),
        );
      } else {
        await alertDialogSingleOption(
          context: context,
          title: "Sorry",
          content: "Please try again",
          option1: "Ok",
          option1Color: mainColor,
          option1Func: () => logout(context),
        );
      }
    } else {
      await alertDialogSingleOption(
        context: context,
        title: "Sorry",
        content: "Please try again",
        option1: "Ok",
        option1Color: mainColor,
        option1Func: () => logout(context),
      );
    }
  } catch (error) {
    await alertDialogSingleOption(
      context: context,
      title: "Sorry",
      content: "An error occured",
      option1: "Ok",
      option1Color: mainColor,
      option1Func: () => logout(context),
    );
  }
}
