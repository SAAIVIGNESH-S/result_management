import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';
import '../../screens/common/auth_screen.dart';

Future<bool> resetPassword(
    {@required BuildContext context, @required body}) async {
  try {
    var request = http.Request(
        'PUT', Uri.parse('https://result.onrender.com/forget-password'));
    request.body = body;

    http.StreamedResponse response = await request.send();
    int status = response.statusCode;

    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      print(res);
      if (res.containsKey("message")) {
        await alertDialogSuccess(
            context: context,
            content: res["message"],
            option1Func: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            });
        return true;
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

  return false;
}
