import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../providers/data.dart';

import '../../screens/admin/admin_restrict_screen.dart';

Future<void> adminEditRestrictions(
    {@required BuildContext context, @required body}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT', Uri.parse('https://result.onrender.com/edit-dropdown'));
    request.body = body;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    int status = response.statusCode;

    if (status == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      if (res.containsKey("dropDown")) {
        print(res);
        await alertDialogSuccess(
            context: context,
            content: "Edited Successfully",
            option1Func: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed(AdminRestrictScreen.routeName);
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
