import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:email_otp/email_otp.dart';
import 'package:result_app/api/common/check_email.dart';
import 'package:result_app/api/common/reset_password.dart';
import 'package:result_app/screens/common/auth_screen.dart';

import '../../helpers/colors.dart';

import '../../widgets/spinner.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  static const routeName = '/forgot-password-screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EmailOTP myauth = EmailOTP();

  bool _isEmailEnabled = true;
  bool _isSendOTP = false;
  bool _isSent = false;

  bool _isOTPEnabled = false;
  bool _isVerifyOTP = false;
  bool _isVerified = false;

  final _emailForm = GlobalKey<FormState>();
  final _resetPasswordForm = GlobalKey<FormState>();

  String password;

  bool _passwordVisible = false;
  bool _otpVisible = false;
  bool _isResetPassword = false;

  Future<void> _sendMail() async {
    final isValid = _emailForm.currentState.validate();

    if (!isValid) {
      return;
    }

    _emailForm.currentState.save();

    setState(() {
      _isLoading = true;
      _isSendOTP = true;
      _isEmailEnabled = false;
    });
    if (await checkEmail(
      context: context,
      body: json.encode(
        {"email": _emailController.text.trim()},
      ),
    )) {
      myauth.setConfig(
        appName: "Acad",
        userEmail: _emailController.text.trim(),
        otpLength: 6,
        otpType: OTPType.mixed,
      );

      if (await myauth.sendOTP() == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "OTP has been sent",
              textAlign: TextAlign.center,
            ),
          ),
        );
        setState(() {
          _isOTPEnabled = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Oops, Failed to send OTP",
              textAlign: TextAlign.center,
            ),
          ),
        );
        setState(() {
          _isEmailEnabled = true;
        });
      }
      setState(() {
        _isLoading = false;
        _isSendOTP = false;
        _isSent = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isSendOTP = false;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isVerifyOTP = true;
      _isOTPEnabled = false;
    });
    if (await myauth.verifyOTP(otp: _otpController.text.trim()) == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "OTP is verified",
            textAlign: TextAlign.center,
          ),
        ),
      );
      setState(() {
        _isVerified = true;
        _isOTPEnabled = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Invalid OTP",
            textAlign: TextAlign.center,
          ),
        ),
      );
      setState(() {
        _isOTPEnabled = true;
      });
    }

    setState(() {
      _isVerifyOTP = false;
    });
  }

  Future<void> _resetPassword() async {
    final isValid = _resetPasswordForm.currentState.validate();

    if (!isValid) {
      return;
    }

    _resetPasswordForm.currentState.save();

    setState(() {
      _isResetPassword = true;
    });

    await resetPassword(
      context: context,
      body: json.encode({
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim()
      }),
    );

    setState(() {
      _isResetPassword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: _isLoading
          ? const Spinner()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Column(
                      children: [
                        Form(
                          key: _emailForm,
                          child: TextFormField(
                            controller: _emailController,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              hintText: "Enter Email",
                              enabled: _isEmailEnabled,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Icon(Icons.person),
                              ),
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "Enter email";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) async {
                              await _sendMail();
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.025,
                        ),
                        _isSendOTP
                            ? const Spinner()
                            : ElevatedButton(
                                onPressed: _isSent
                                    ? null
                                    : () async {
                                        await _sendMail();
                                      },
                                child: const Text(
                                  "Send OTP",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                      ],
                    ),
                    _isSent
                        ? Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              TextFormField(
                                controller: _otpController,
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  hintText: "Enter OTP",
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Icon(Icons.mobile_friendly),
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: IconButton(
                                      icon: Icon(
                                        _otpVisible
                                            ? Icons.remove_red_eye_outlined
                                            : CupertinoIcons.eye_slash,
                                        color: mainColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _otpVisible = !_otpVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                enabled: _isOTPEnabled,
                                obscureText: !_otpVisible,
                                onFieldSubmitted: (_) async {
                                  await _verifyOTP();
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.025,
                              ),
                              _isVerifyOTP
                                  ? const Spinner()
                                  : ElevatedButton(
                                      onPressed: _isVerified
                                          ? null
                                          : () async {
                                              await _verifyOTP();
                                            },
                                      child: const Text(
                                        "Verify OTP",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                            ],
                          )
                        : SizedBox(
                            height: size.height * 0.03,
                          ),
                    _isVerified
                        ? Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Form(
                                key: _resetPasswordForm,
                                child: TextFormField(
                                  controller: _passwordController,
                                  textInputAction: TextInputAction.done,
                                  autocorrect: false,
                                  cursorColor: Theme.of(context).primaryColor,
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                    hintText: "New Password",
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
                                            _passwordVisible =
                                                !_passwordVisible;
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
                                  onFieldSubmitted: (_) async {
                                    password = _passwordController.text.trim();
                                    await _resetPassword();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              _isResetPassword
                                  ? const Spinner()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await _resetPassword();
                                      },
                                      child: const Text(
                                        "Reset Password",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                            ],
                          )
                        : SizedBox(
                            height: size.height * 0.05,
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
