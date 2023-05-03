import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../models/admin_model.dart';
import '../../providers/data.dart';

Future<List> adminGetProfile({@required BuildContext context}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET',
        Uri.parse('https://result.onrender.com/admin-detail/${data.getId}'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    int status = response.statusCode;
    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      if (res.containsKey("adminDetail")) {
        Map obtainedAdmin = res["adminDetail"][0];

        Admin admin = Admin(
          adminId: obtainedAdmin["adminId"],
          name: obtainedAdmin["name"],
          dob: DateTime.parse(obtainedAdmin["DOB"]),
          email: obtainedAdmin["email"],
          addressLine1: obtainedAdmin["addressLine1"],
          addressLine2: obtainedAdmin["addressLine2"],
          city: obtainedAdmin["city"],
          state: obtainedAdmin["state"],
          country: obtainedAdmin["country"],
          phoneNum: obtainedAdmin["phoneNum"],
        );
        return [true, admin];
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
