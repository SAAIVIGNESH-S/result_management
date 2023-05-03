import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../api/admin/admin_add_faculty.dart';

import '../../helpers/call_alert_dialog.dart';
import '../../helpers/colors.dart';

import '../../widgets/spinner.dart';
import '../../widgets/admin/admin_app_drawer.dart';

class AdminAddFacultyScreen extends StatefulWidget {
  static const routeName = '/admin-add-faculty-screen';

  const AdminAddFacultyScreen({Key key}) : super(key: key);
  @override
  State<AdminAddFacultyScreen> createState() => _AdminAddFacultyScreenState();
}

class _AdminAddFacultyScreenState extends State<AdminAddFacultyScreen> {
  var _isLoading = false;

  final List<String> deptArray = [
    'AD',
    'AU',
    'AE',
    'BT',
    'CE',
    'CS',
    'FT',
    'EC',
    'EE',
    'FT',
    'IT',
    'IS',
    'TT'
  ];

  String name;
  String facultyId;
  String dept;
  DateTime dob;
  DateTime doj;
  String email;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String country;
  String phoneNum;

  final _form = GlobalKey<FormState>();

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();

    if (!isValid) {
      return;
    }
    if (dept == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select department",
      );
      return;
    } else if (dob == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select DOB",
      );
      return;
    } else if (country == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select country",
      );
      return;
    } else if (state == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select state",
      );
      return;
    } else if (city == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select city",
      );
      return;
    }

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    await adminAddFaculty(
      context: context,
      body: json.encode({
        "facultyId": facultyId,
        "name": name,
        "DOB": dob.toIso8601String(),
        "DOJ": DateTime.now().toIso8601String(),
        "department": dept,
        "email": email,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "phoneNum": phoneNum,
      }),
    );

    setState(() {
      _isLoading = false;
      dob = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Faculty'),
        backgroundColor: mainColor,
      ),
      drawer: const AdminAppDrawer(),
      body: _isLoading
          ? const Spinner()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              hintText: "Name",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 61, 60, 60),
                                ),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 61, 60, 60),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "Name can't be empty";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              name = newValue.trim();
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width * 0.5,
                                child: TextFormField(
                                  // controller: _facultyIdController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: Theme.of(context).primaryColor,
                                  decoration: InputDecoration(
                                    hintText: "Faculty ID",
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 61, 60, 60),
                                      ),
                                    ),
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Icon(
                                        Icons.tag,
                                        color: Color.fromARGB(255, 61, 60, 60),
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return "ID can't be empty";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    facultyId = newValue.trim();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: size.width * 0.4,
                                child: DropdownSearch<String>(
                                  popupBarrierColor: Colors.black26,
                                  mode: Mode.DIALOG,
                                  dropdownSearchDecoration: InputDecoration(
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 61, 60, 60),
                                      ),
                                    ),
                                  ),
                                  searchBoxDecoration: InputDecoration(
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 61, 60, 60),
                                      ),
                                    ),
                                  ),
                                  showSearchBox: true,
                                  showSelectedItem: true,
                                  items: deptArray,
                                  label: "Dept",
                                  showAsSuffixIcons: true,
                                  onChanged: (value) {
                                    dept = value;
                                  },
                                  onSaved: (newValue) {
                                    dept = newValue;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Container(
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromARGB(255, 61, 60, 60),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: const [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(Icons.cake),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "DOB",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      dob = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now().subtract(
                                          const Duration(days: 36500),
                                        ),
                                        lastDate: DateTime.now(),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: Color(0xFF6F35A5),
                                              ),
                                            ),
                                            child: child,
                                          );
                                        },
                                      );
                                      setState(() {});
                                    },
                                    child: dob == null
                                        ? const Text(
                                            "Select DOB",
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        : Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format(dob),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              hintText: "Email Address",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 61, 60, 60),
                                ),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  Icons.email_rounded,
                                  color: Color.fromARGB(255, 61, 60, 60),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "Email can't be empty";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              email = newValue.trim();
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Container(
                            height: size.height * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromARGB(255, 61, 60, 60),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  cursorColor: Theme.of(context).primaryColor,
                                  decoration: const InputDecoration(
                                    hintText: "Address line 1",
                                    fillColor: Colors.white,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Icon(
                                        Icons.house_rounded,
                                        color: Color.fromARGB(255, 61, 60, 60),
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return "Address Line 1 can't be empty";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    addressLine1 = newValue.trim();
                                  },
                                ),
                                SizedBox(
                                  height: size.height * 0.005,
                                ),
                                const Divider(thickness: 1),
                                SizedBox(
                                  height: size.height * 0.005,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  cursorColor: Theme.of(context).primaryColor,
                                  decoration: const InputDecoration(
                                    hintText: "Address line 2",
                                    fillColor: Colors.white,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Icon(
                                        Icons.house,
                                        color: Color.fromARGB(255, 61, 60, 60),
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return "Address Line 2 can't be empty";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    addressLine2 = newValue.trim();
                                  },
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Container(
                            height: size.height * 0.23,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromARGB(255, 61, 60, 60),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SelectState(
                                onCountryChanged: (value) {
                                  setState(() {
                                    country = value;
                                  });
                                },
                                onStateChanged: (value) {
                                  setState(() {
                                    state = value;
                                  });
                                },
                                onCityChanged: (value) {
                                  setState(() {
                                    city = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              hintText: "Phone number",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 61, 60, 60),
                                ),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  Icons.phone,
                                  color: Color.fromARGB(255, 61, 60, 60),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "Phone Number can't be empty";
                              }
                              if (value.trim().toString().length != 10) {
                                return "Phone Number should be of 10 digits";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              phoneNum = newValue.trim();
                            },
                            onFieldSubmitted: (value) async {
                              await _saveForm();
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _saveForm();
                            },
                            child: const Text(
                              "SUBMIT",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
