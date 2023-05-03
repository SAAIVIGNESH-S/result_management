import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/common/get_social_token.dart';

import '../../helpers/call_alert_dialog.dart';
import '../../helpers/colors.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount> googleLogin() => _googleSignIn.signIn();

  static Future<GoogleSignInAccount> googleLogout() => _googleSignIn.signOut();
}

Future<void> googleSignIn({@required BuildContext context}) async {
  final user = await GoogleSignInApi.googleLogin();
  if (user == null) {
    await alertDialogSingleOption(
      context: context,
      title: "Error",
      content: "No user selected",
      option1: "Ok",
      option1Color: mainColor,
      option1Func: () => Navigator.of(context).pop(),
    );
  } else {
    await getSocialToken(context: context, email: user.email, type: "google");
  }
}
