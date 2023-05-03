import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';
import '../../helpers/logout.dart';

import '../../providers/data.dart';

import '../../screens/admin/admin_view_batches_screen.dart';

Future<void> adminAddEnrollment(
    {@required BuildContext context, @required body}) async {
  try {
    Data data = Provider.of<Data>(context, listen: false);

    var headers = {
      'Authorization': 'Bearer ${data.getAccessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT', Uri.parse('https://result.onrender.com/batch-add-course'));
    request.body = body;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    int status = response.statusCode;

    if (status == 200) {
      var res = json.decode(await response.stream.bytesToString());
      await alertDialogSuccess(
          context: context,
          content: res["success"],
          option1Func: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacementNamed(AdminViewBatchesScreen.routeName);
          });
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
