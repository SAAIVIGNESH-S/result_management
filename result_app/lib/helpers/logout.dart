import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/aad_oauth.dart';

import '../api/common/google_signin.dart';

import '../providers/data.dart';

import '../screens/common/auth_screen.dart';

Future<void> logout(BuildContext context) async {
  Data data = Provider.of<Data>(context, listen: false);
  if (data.getLoginType == "google") {
    await GoogleSignInApi.googleLogout();
  }
  if (data.getLoginType == "microsoft") {
    final Config config = Config(
      tenant: 'c51a158c-bcc9-4608-947a-a30d9208cd47',
      clientId: 'e30778f0-66a1-4377-b41d-ced448babc1d',
      scope: 'openid profile offline_access',
      redirectUri:
          'https://login.microsoftonline.com/common/oauth2/nativeclient',
    );

    final AadOAuth oauth = AadOAuth(config);
    await oauth.logout();
  }
  data.clearAllData();
  Navigator.of(context).pop();
  Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
}
