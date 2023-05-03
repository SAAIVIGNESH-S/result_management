import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:result_app/api/admin/admin_add_course.dart';

import '../../api/admin/admin_get_faculty_id.dart';

import '../../helpers/colors.dart';
import '../../helpers/call_alert_dialog.dart';

import '../../widgets/spinner.dart';
import '../../widgets/admin/admin_app_drawer.dart';
import '../../widgets/error_display.dart';

class AdminAddCourseScreen extends StatefulWidget {
  const AdminAddCourseScreen({Key key}) : super(key: key);

  static const routeName = '/admin-add-course-screen';

  @override
  State<AdminAddCourseScreen> createState() => _AdminAddCourseScreenState();
}

class _AdminAddCourseScreenState extends State<AdminAddCourseScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await _fetchFacultyId();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  final List<String> semNoArray = ['1', '2', '3', '4', '5', '6', '7', '8'];
  final List<String> typeArray = ['Theory', 'Embedded'];
  List<String> facultyIdArray = [];
  List<String> facultyNameArray = [];
  List<String> displayArray = [];

  String id;
  String name;
  int semNo;
  String offeredBy;
  int hours;
  String type;
  int credits;
  String facultyId;

  final _form = GlobalKey<FormState>();

  var _isLoading = true;

  bool _isSuccess = false;

  Future<void> _fetchFacultyId() async {
    setState(() {
      _isLoading = true;
    });

    var res = await adminGetFacultyId(context: context);
    _isSuccess = res[0];
    if (_isSuccess) {
      facultyIdArray = res[1] as List<String>;
      facultyNameArray = res[2] as List<String>;

      for (int i = 0; i < facultyIdArray.length; i++) {
        displayArray.add('${facultyIdArray[i]} - ${facultyNameArray[i]}');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();

    if (!isValid) {
      return;
    }

    if (semNo == null && type == null && facultyId == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select semNo, type and faculty id",
      );
      return;
    } else if (semNo == null && type == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select sem and type",
      );
      return;
    } else if (type == null && facultyId == null) {
      alertDialog(
        context: context,
        title: "Error",
        content: "Please select type and faculty id ",
      );
      return;
    } else if (semNo == null && facultyId == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select semNo and faculty id",
      );
      return;
    } else if (semNo == null) {
      alertDialog(
        context: context,
        title: "Error",
        content: "Please select semNo",
      );
      return;
    } else if (type == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select type",
      );
      return;
    } else if (facultyId == null) {
      await alertDialog(
        context: context,
        title: "Error",
        content: "Please select faculty",
      );
      return;
    }

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    await adminAddCourse(
      context: context,
      body: json.encode({
        "_id": id,
        "name": name,
        "semNo": semNo,
        "offeredBy": offeredBy,
        "type": type.toLowerCase(),
        "hours": hours,
        "credits": credits,
        "facultyId": facultyId
      }),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Courses'),
        backgroundColor: mainColor,
      ),
      drawer: const AdminAppDrawer(),
      body: _isLoading
          ? const Spinner()
          : _isSuccess
              ? SingleChildScrollView(
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
                                height: size.height * 0.05,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  hintText: "Course Id",
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
                                      Icons.insert_drive_file_outlined,
                                      color: Color.fromARGB(255, 61, 60, 60),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return "Course Id can't be empty";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  id = newValue.trim();
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  hintText: "Course Name",
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
                                      Icons.text_fields,
                                      color: Color.fromARGB(255, 61, 60, 60),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return "Course Name can't be empty";
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: DropdownSearch<String>(
                                      popupBarrierColor: Colors.black26,
                                      mode: Mode.DIALOG,
                                      dropdownSearchDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                      ),
                                      searchBoxDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                      ),
                                      showSearchBox: true,
                                      showSelectedItem: true,
                                      items: semNoArray,
                                      label: "Sem No",
                                      showAsSuffixIcons: true,
                                      onChanged: (value) {
                                        semNo = int.parse(value);
                                      },
                                      onSaved: (newValue) {
                                        semNo = int.parse(newValue);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: DropdownSearch<String>(
                                      maxHeight: size.height * 0.3,
                                      popupBarrierColor: Colors.black26,
                                      mode: Mode.DIALOG,
                                      dropdownSearchDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                      ),
                                      searchBoxDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                      ),
                                      showSearchBox: true,
                                      showSelectedItem: true,
                                      items: typeArray,
                                      label: "Type",
                                      showAsSuffixIcons: true,
                                      onChanged: (value) {
                                        type = value;
                                      },
                                      onSaved: (newValue) {
                                        type = newValue;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        hintText: "Offered By",
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Icon(
                                            Icons.local_offer_outlined,
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return "Offered by can't be empty";
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) {
                                        offeredBy = newValue.trim();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: DropdownSearch<String>(
                                      maxHeight: size.height * 0.45,
                                      popupBarrierColor: Colors.black26,
                                      mode: Mode.DIALOG,
                                      dropdownSearchDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                      ),
                                      searchBoxDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                      ),
                                      showSearchBox: true,
                                      showSelectedItem: true,
                                      items: displayArray,
                                      label: "Faculty Id",
                                      showAsSuffixIcons: true,
                                      onChanged: (value) {
                                        facultyId = value.split(" ")[0];
                                        print(facultyId);
                                      },
                                      onSaved: (newValue) {
                                        facultyId = newValue.split(" ")[0];
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        hintText: "Credits",
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Icon(
                                            Icons.onetwothree,
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return "Credits can't be empty";
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) {
                                        credits = int.parse(newValue);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        hintText: "Hours",
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Icon(
                                            Icons.timelapse,
                                            color:
                                                Color.fromARGB(255, 61, 60, 60),
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return "Hours can't be empty";
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) {
                                        hours = int.parse(newValue);
                                      },
                                      onFieldSubmitted: (value) {
                                        hours = int.parse(value);
                                        _saveForm();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.04,
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
                )
              : errorDisplay("Couldn't fetch faculties"),
    );
  }
}
