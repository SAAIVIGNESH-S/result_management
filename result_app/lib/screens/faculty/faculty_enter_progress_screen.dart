import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../api/faculty/faculty_get_dropdown.dart';
import '../../api/faculty/faculty_get_students.dart';
import '../../api/faculty/faculty_add_progress.dart';

import '../../models/enrollment_model.dart';

import '../../helpers/colors.dart';

import '../../widgets/error_display.dart';
import '../../widgets/spinner.dart';

class FacultyEnterProgressScreen extends StatefulWidget {
  const FacultyEnterProgressScreen({Key key}) : super(key: key);

  static const routeName = '/faculty-enter-progress-screen';

  @override
  State<FacultyEnterProgressScreen> createState() =>
      _FacultyEnterProgressScreenState();
}

class _FacultyEnterProgressScreenState
    extends State<FacultyEnterProgressScreen> {
  var _isLoading = true;
  var _isSuccess = false;
  var _isStudentSuccess = false;

  List<String> options = [];
  List _students = [];

  final _form = GlobalKey<FormState>();
  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, FocusNode> _focusNodes = {};
  final Map _formAnswers = {};

  String selectedOption;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });

      var res = await facultyGetDropdown(context: context);

      _isSuccess = res[0];
      if (_isSuccess) {
        options = res[1] as List<String>;

        Enrollment obtainedClass = ModalRoute.of(context).settings.arguments;

        if (obtainedClass.courseType.toLowerCase() == 'theory') {
          options.remove('lab');
        }

        var studentRes = await facultyGetStudents(
          context: context,
          body: json.encode({
            "batchYear": obtainedClass.batchYear,
            "department": obtainedClass.dept
          }),
        );

        _isStudentSuccess = studentRes[0];
        if (_isStudentSuccess) {
          _students = studentRes[1] as List;

          for (String student in _students) {
            _textControllers.addAll(
              {
                int.parse(student.substring(5, 8)): TextEditingController(),
              },
            );
            _focusNodes.addAll(
              {
                int.parse(student.substring(5, 8)): FocusNode(),
              },
            );
          }
        }
      }

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    List studRollNo = [];
    List marks = [];
    _formAnswers.forEach((key, value) {
      studRollNo.add(key);
      marks.add(value);
    });

    Enrollment obtainedClass = ModalRoute.of(context).settings.arguments;
    await facultyEnterProgress(
      context: context,
      body: json.encode({
        "batchYear": obtainedClass.batchYear,
        "studRollNo": studRollNo,
        "examType": selectedOption,
        "courseId": obtainedClass.courseId,
        "currentSem": obtainedClass.sem,
        "marks": marks,
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
        title: const Text('Enter progress'),
        backgroundColor: mainColor,
        actions: [
          if (selectedOption != null)
            TextButton(
              onPressed: () async {
                await _saveForm();
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: _isLoading
          ? const Spinner()
          : _isSuccess
              ? _isStudentSuccess
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: SizedBox(
                          height: size.height,
                          child: Column(
                            children: [
                              DropdownSearch<String>(
                                maxHeight: size.height * 0.2,
                                dialogMaxWidth: size.width * 0.4,
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
                                items: options,
                                label: "Exam Type",
                                showAsSuffixIcons: true,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value;
                                  });
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    selectedOption = newValue;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              selectedOption != null
                                  ? SizedBox(
                                      height: size.height * 0.7,
                                      child: Form(
                                        key: _form,
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 2.5,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                          ),
                                          itemCount: _students.length,
                                          itemBuilder: (context, index) {
                                            return TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  index == _students.length - 1
                                                      ? TextInputAction.done
                                                      : TextInputAction.next,
                                              autocorrect: false,
                                              cursorColor: Theme.of(context)
                                                  .primaryColor,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                      255,
                                                      61,
                                                      60,
                                                      60,
                                                    ),
                                                  ),
                                                ),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Text(_students[index]),
                                                ),
                                              ),
                                              controller: _textControllers
                                                  .values
                                                  .elementAt(
                                                _textControllers.keys
                                                    .toList()
                                                    .indexOf(
                                                      int.parse(
                                                        _students[index]
                                                            .substring(5, 8),
                                                      ),
                                                    ),
                                              ),
                                              focusNode:
                                                  _focusNodes.values.elementAt(
                                                _focusNodes.keys
                                                    .toList()
                                                    .indexOf(
                                                      int.parse(
                                                        _students[index]
                                                            .substring(5, 8),
                                                      ),
                                                    ),
                                              ),
                                              validator: (value) {
                                                if (value.trim().isEmpty) {
                                                  return "This is an required field!";
                                                }
                                                if (int.tryParse(value) ==
                                                    null) {
                                                  return "Enter valid number";
                                                }
                                                if ((selectedOption ==
                                                        "assignment") &&
                                                    (int.parse(value) < 0 ||
                                                        int.parse(value) >
                                                            20)) {
                                                  return "Valid range (0-20)";
                                                }
                                                if ((selectedOption == "cat1" ||
                                                        selectedOption ==
                                                            "cat2") &&
                                                    (int.parse(value) < 0 ||
                                                        int.parse(value) >
                                                            50)) {
                                                  return "Valid range (0-50)";
                                                }
                                                if ((selectedOption == "sem" ||
                                                        selectedOption ==
                                                            "lab" ||
                                                        selectedOption ==
                                                            "attendance") &&
                                                    (int.parse(value) < 0 ||
                                                        int.parse(value) >
                                                            100)) {
                                                  return "Valid range (0-100)";
                                                }
                                                return null;
                                              },
                                              onSaved: (textString) {
                                                textString = textString.trim();
                                                if (textString.isNotEmpty) {
                                                  _formAnswers.update(
                                                    _students[index],
                                                    (value) => textString,
                                                    ifAbsent: () => textString,
                                                  );
                                                } else {
                                                  _formAnswers.update(
                                                    _students[index],
                                                    (value) => null,
                                                    ifAbsent: () => null,
                                                  );
                                                }
                                              },
                                              onFieldSubmitted: (textString) {
                                                index != _students.length - 1
                                                    ? FocusScope.of(context)
                                                        .requestFocus(
                                                        _focusNodes.values
                                                            .elementAt(
                                                          _focusNodes.keys
                                                              .toList()
                                                              .indexOf(
                                                                int.parse(
                                                                  _students[
                                                                          index +
                                                                              1]
                                                                      .substring(
                                                                          5, 8),
                                                                ),
                                                              ),
                                                        ),
                                                      )
                                                    : _saveForm();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : errorDisplay("Please select exam type"),
                            ],
                          ),
                        ),
                      ),
                    )
                  : errorDisplay("Couldn't fetch students")
              : errorDisplay("Couldn't fetch forms"),
    );
  }
}
