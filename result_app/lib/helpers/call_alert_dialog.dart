import 'package:flutter/material.dart';

import '../widgets/alert_dialog.dart';

import './colors.dart';

Future<void> alertDialog(
    {@required BuildContext context,
    @required String title,
    @required String content}) async {
  await showAlertDialog(
    context: context,
    title: title,
    titleColor: Colors.red,
    content: content,
    option1: "Ok",
    option1Func: () => Navigator.of(context).pop(),
    option1Color: mainColor,
    option2: null,
    option2Color: null,
    option2Func: null,
  );
}

Future<void> alertDialogSingleOption({
  @required BuildContext context,
  @required String title,
  @required String content,
  @required String option1,
  @required Color option1Color,
  @required Function option1Func,
}) async {
  await showAlertDialog(
    context: context,
    title: title,
    titleColor: Colors.red,
    content: content,
    option1: option1,
    option1Func: option1Func,
    option1Color: option1Color,
    option2: null,
    option2Color: null,
    option2Func: null,
  );
}

Future<void> alertDialogSuccess({
  @required BuildContext context,
  @required String content,
  @required Function option1Func,
}) async {
  await showAlertDialog(
    context: context,
    title: "Success",
    titleColor: Colors.green,
    content: content,
    option1: "Ok",
    option1Func: option1Func,
    option1Color: mainColor,
    option2: null,
    option2Color: null,
    option2Func: null,
  );
}

// Future<void> alertDialog200({
//   @required BuildContext context,
//   @required http.StreamedResponse response,
// }) async {
//   await showAlertDialog(
//     context: context,
//     title: response.statusCode.toString(),
//     titleColor: Colors.green,
//     content: response.request.toString(),
//     option1: "Ok",
//     option1Func: () => Navigator.of(context).pop(),
//     option1Color: const mainColor,
//     option2: null,
//     option2Color: null,
//     option2Func: null,
//   );
// }

// Future<void> alertDialog401({
//   @required BuildContext context,
//   @required http.StreamedResponse response,
// }) async {
//   await showAlertDialog(
//     context: context,
//     title: response.reasonPhrase,
//     titleColor: Colors.red,
//     content: "Please try again!!",
//     option1: "Ok",
//     option1Func: () => Navigator.of(context).pop(),
//     option1Color: const mainColor,
//     option2: null,
//     option2Color: null,
//     option2Func: null,
//   );
// }

Future<void> alertDialogElse({
  @required BuildContext context,
  @required String title,
  @required String content,
}) async {
  await showAlertDialog(
    context: context,
    title: title,
    titleColor: Colors.red,
    content: content,
    option1: "Ok",
    option1Func: () => Navigator.of(context).pop(),
    option1Color: mainColor,
    option2: null,
    option2Color: null,
    option2Func: null,
  );
}

Future<void> alertDialogError({@required BuildContext context}) async {
  await showAlertDialog(
    context: context,
    title: "An error occured",
    titleColor: Colors.red,
    content: "Please try again!!",
    option1: "Ok",
    option1Func: () => Navigator.of(context).pop(),
    option1Color: Colors.red,
    option2: null,
    option2Color: null,
    option2Func: null,
  );
}
