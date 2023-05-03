import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:result_app/widgets/admin/admin_app_drawer.dart';
import 'package:result_app/widgets/faculty/faculty_app_drawer.dart';
import 'package:result_app/widgets/spinner.dart';
import 'package:result_app/widgets/student/student_app_drawer.dart';

import '../../api/common/check_password.dart';
import '../../api/common/update_password.dart';
import '../../helpers/colors.dart';
import '../../helpers/logout.dart';
import '../../providers/data.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key key}) : super(key: key);

  static const routeName = '/change-password-screen';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _checkPasswordController =
      TextEditingController();

  //Password visible
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _checkPasswordVisible = false;

  //for disable after submitting
  bool _isOldPasswordEnabled = true;
  bool _isNewPasswordEnabled = false;
  bool _isCheckPasswordEnabled = false;

  String oldPassword;
  String newPassword;
  String checkPassword;

  //for validators..
  final _oldPasswordForm = GlobalKey<FormState>();
  final _newPasswordForm = GlobalKey<FormState>();
  final _checkPasswordForm = GlobalKey<FormState>();

  bool _isNewPasswordVisible = false;
  bool _isCheckPasswordVisible = false;
  var _isLoading = false;

  Future<void> _savePasswordForm(
      GlobalKey<FormState> key, Function api, Function function) async {
    final isValid = key.currentState.validate();

    if (!isValid) {
      return;
    }

    key.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (api != null) {
      if (await api()) function();
    } else {
      function();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Data data = Provider.of<Data>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      drawer: data.role == 'student'
          ? const StudentAppDrawer()
          : data.role == 'faculty'
              ? const FacultyAppDrawer()
              : data.role == 'admin'
                  ? const AdminAppDrawer()
                  : Drawer(
                      child: Column(
                        children: [
                          Container(
                            color: mainColor,
                            height: size.height * 0.3,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: ListTile(
                              leading: const Icon(Icons.login_outlined),
                              title: const Text('Log out'),
                              onTap: () {
                                logout(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
      body: _isLoading
          ? const Spinner()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Form(
                      key: _oldPasswordForm,
                      child: TextFormField(
                        controller: _oldPasswordController,
                        cursorColor: Theme.of(context).primaryColor,
                        obscureText: !_oldPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Enter Current Password",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Icon(Icons.lock_clock),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: IconButton(
                              icon: Icon(
                                _oldPasswordVisible
                                    ? Icons.remove_red_eye_outlined
                                    : CupertinoIcons.eye_slash,
                                color: mainColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _oldPasswordVisible = !_oldPasswordVisible;
                                });
                              },
                            ),
                          ),
                          enabled: _isOldPasswordEnabled,
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
                        onFieldSubmitted: (_) {
                          _savePasswordForm(
                            _oldPasswordForm,
                            () => checkOldPassword(
                              context: context,
                              body: json.encode({
                                "email": data.getEmail,
                                "password": _oldPasswordController.text.trim()
                              }),
                            ),
                            () => setState(() {
                              _isOldPasswordEnabled = false;
                              _isNewPasswordEnabled = true;
                              _isNewPasswordVisible = true;
                              oldPassword = _oldPasswordController.text.trim();
                            }),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    if (!_isNewPasswordVisible)
                      ElevatedButton(
                        onPressed: () {
                          _savePasswordForm(
                            _oldPasswordForm,
                            () => checkOldPassword(
                              context: context,
                              body: json.encode({
                                "email": data.getEmail,
                                "password": _oldPasswordController.text.trim()
                              }),
                            ),
                            () => setState(() {
                              _isOldPasswordEnabled = false;
                              _isNewPasswordEnabled = true;
                              _isNewPasswordVisible = true;
                              oldPassword = _oldPasswordController.text.trim();
                            }),
                          );
                        },
                        child: const Text(
                          "Ok",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    if (_isNewPasswordVisible)
                      Form(
                        key: _newPasswordForm,
                        child: TextFormField(
                          controller: _newPasswordController,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            hintText: "Enter New Password",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(Icons.lock),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: IconButton(
                                icon: Icon(
                                  _newPasswordVisible
                                      ? Icons.remove_red_eye_outlined
                                      : CupertinoIcons.eye_slash,
                                  color: mainColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _newPasswordVisible = !_newPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          enabled: _isNewPasswordEnabled,
                          obscureText: !_newPasswordVisible,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password can't be empty";
                            }
                            if (value.trim().isEmpty) {
                              return "Password contains while spaces";
                            }
                            if (value.trim() == oldPassword) {
                              return "Old Password and New Password can't be same";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) async {
                            _savePasswordForm(
                              _newPasswordForm,
                              null,
                              () => setState(() {
                                _isNewPasswordEnabled = false;
                                _isCheckPasswordEnabled = true;
                                _isCheckPasswordVisible = true;
                                oldPassword =
                                    _oldPasswordController.text.trim();
                                newPassword =
                                    _newPasswordController.text.trim();
                              }),
                            );
                          },
                        ),
                      ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    if (_isNewPasswordVisible && !_isCheckPasswordVisible)
                      ElevatedButton(
                        onPressed: () {
                          _savePasswordForm(
                            _newPasswordForm,
                            null,
                            () => setState(() {
                              _isNewPasswordEnabled = false;
                              _isCheckPasswordEnabled = true;
                              _isCheckPasswordVisible = true;
                              oldPassword = _oldPasswordController.text.trim();
                              newPassword = _newPasswordController.text.trim();
                            }),
                          );
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    if (_isCheckPasswordVisible)
                      Form(
                        key: _checkPasswordForm,
                        child: TextFormField(
                          controller: _checkPasswordController,
                          autocorrect: false,
                          cursorColor: Theme.of(context).primaryColor,
                          obscureText: !_checkPasswordVisible,
                          enabled: _isCheckPasswordEnabled,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(Icons.lock),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: IconButton(
                                icon: Icon(
                                  _checkPasswordVisible
                                      ? Icons.remove_red_eye_outlined
                                      : CupertinoIcons.eye_slash,
                                  color: mainColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _checkPasswordVisible =
                                        !_checkPasswordVisible;
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
                            if (value.trim() != newPassword) {
                              return "New Password and Confirm Password should be same";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) async {
                            _savePasswordForm(
                              _checkPasswordForm,
                              () => updatePassword(
                                context: context,
                                body: json.encode({
                                  "email": data.getEmail,
                                  "password":
                                      _checkPasswordController.text.trim()
                                }),
                              ),
                              () => setState(() {
                                _isCheckPasswordEnabled = false;
                                checkPassword =
                                    _checkPasswordController.text.trim();
                              }),
                            );
                          },
                        ),
                      ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    if (_isCheckPasswordVisible)
                      ElevatedButton(
                        onPressed: () {
                          _savePasswordForm(
                            _checkPasswordForm,
                            () => updatePassword(
                              context: context,
                              body: json.encode({
                                "email": data.getEmail,
                                "password": _checkPasswordController.text.trim()
                              }),
                            ),
                            () => setState(() {
                              _isCheckPasswordEnabled = false;
                              checkPassword =
                                  _checkPasswordController.text.trim();
                            }),
                          );
                        },
                        child: const Text(
                          "Change Password",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
