import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decode_token/jwt_decode_token.dart';

import '../../api/common/get_token.dart';
import '../../api/common/get_social_token.dart';
import '../../api/common/google_signin.dart';

import '../../helpers/call_alert_dialog.dart';

import '../../helpers/colors.dart';

import '../../widgets/social_icon.dart';
import '../../widgets/spinner.dart';

import './forgot_password_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  static const routeName = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authForm = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _passwordFocusNode = FocusNode();

  String email;
  String password;

  bool _isLoading = false;
  bool _passwordVisible = false;

  void _clearText() {
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _saveForm() async {
    final isValid = _authForm.currentState.validate();

    if (!isValid) {
      return;
    }

    _authForm.currentState.save();

    setState(() {
      _isLoading = true;
    });

    await getToken(context: context, email: email, password: password);

    _clearText();

    setState(() {
      _isLoading = false;
    });
  }

  static final Config config = Config(
    tenant: 'c51a158c-bcc9-4608-947a-a30d9208cd47',
    clientId: 'e30778f0-66a1-4377-b41d-ced448babc1d',
    scope: 'openid profile offline_access',
    redirectUri: 'https://login.microsoftonline.com/common/oauth2/nativeclient',
  );

  final AadOAuth oauth = AadOAuth(config);

  Future<void> _msLogin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await oauth.login();
      var accessToken = await oauth.getAccessToken();
      Map decodedDetails = decodeJwt(accessToken);
      var userEmail = decodedDetails['email'];
      getSocialToken(context: context, email: userEmail, type: "microsoft");
    } catch (e) {
      await alertDialogError(context: context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
      },
      child: Scaffold(
        body: _isLoading
            ? const Spinner()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: size.height,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      SvgPicture.asset(
                        "assets/images/login.svg",
                        height: size.height * 0.4,
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Form(
                        key: _authForm,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: const InputDecoration(
                                hintText: "Your Email",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Icon(Icons.person),
                                ),
                              ),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return "User Name can't be empty";
                                }
                                return null;
                              },
                              onSaved: (_) {
                                email = _emailController.text.trim();
                              },
                              onFieldSubmitted: (_) {
                                email = _emailController.text.trim();
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.done,
                              autocorrect: false,
                              cursorColor: Theme.of(context).primaryColor,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                hintText: "Your Password",
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Icon(Icons.lock),
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.remove_red_eye_outlined
                                          : CupertinoIcons.eye_slash,
                                      color: mainColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Password can't be empty";
                                }
                                if (value.trim().isEmpty) {
                                  return "Password contains while spaces";
                                }
                                return null;
                              },
                              onSaved: (_) async {
                                password = _passwordController.text.trim();
                              },
                              onFieldSubmitted: (_) async {
                                password = _passwordController.text.trim();
                                await _saveForm();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextButton(
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      ForgotPasswordScreen.routeName);
                                },
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await _saveForm();
                              },
                              child: const Text(
                                "LOG IN",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      SizedBox(
                        width: size.width * 0.8,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 161, 158, 158),
                                height: 1.5,
                              ),
                            ),
                            Text(
                              "  OR  ",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 161, 158, 158),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialIcon(
                            iconSrc: "assets/images/google.svg",
                            func: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await googleSignIn(context: context);
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ),
                          SocialIcon(
                            iconSrc: "assets/images/microsoft.svg",
                            func: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await _msLogin();
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
