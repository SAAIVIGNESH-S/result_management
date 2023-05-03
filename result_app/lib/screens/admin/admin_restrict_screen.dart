import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:result_app/api/admin/admin_edit_restrictions.dart';
import 'package:result_app/widgets/error_display.dart';
import 'package:result_app/widgets/spinner.dart';

import '../../api/admin/admin_get_dropdown.dart';
import '../../helpers/colors.dart';

import '../../widgets/admin/admin_app_drawer.dart';

class AdminRestrictScreen extends StatefulWidget {
  const AdminRestrictScreen({Key key}) : super(key: key);

  static const routeName = '/admin-restrict-screen';

  @override
  State<AdminRestrictScreen> createState() => _AdminRestrictScreenState();
}

class _AdminRestrictScreenState extends State<AdminRestrictScreen> {
  var _isLoading = true;
  var _isSuccess = false;
  String option;

  String _groupValue = "None";
  final List<String> _status = [
    "none",
    "cat1",
    "cat2",
    "assignment",
    "attendance",
    "lab",
    "sem",
  ];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });

      var res = await adminGetDropdown(context: context);

      _isSuccess = res[0];
      if (_isSuccess) {
        option = res[1] as String;
      }

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restrictions"),
      ),
      drawer: const AdminAppDrawer(),
      body: _isLoading
          ? const Spinner()
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: _isSuccess
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "Current option: $option",
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        RadioGroup<String>.builder(
                          spacebetween: 40,
                          groupValue: _groupValue,
                          onChanged: (value) => setState(() {
                            _groupValue = value;
                          }),
                          items: _status,
                          itemBuilder: (item) => RadioButtonBuilder(
                            item,
                          ),
                          activeColor: mainColor,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await adminEditRestrictions(
                              context: context,
                              body: json.encode({"examType": _groupValue}),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: const Text("Enable"),
                        )
                      ],
                    )
                  : errorDisplay("An error occured"),
            ),
    );
  }
}
