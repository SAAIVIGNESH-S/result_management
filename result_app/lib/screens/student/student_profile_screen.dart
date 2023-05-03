import 'package:flutter/material.dart';

import '../../api/student/student_get_profile.dart';

import '../../widgets/spinner.dart';
import '../../widgets/list_profile.dart';
import '../../widgets/error_display.dart';

import '../../models/student_model.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key key}) : super(key: key);
  static const routeName = '/student-profile-screen';
  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  var _isLoading = true;
  var _isSuccess = false;

  Student student;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });

      var res = await studentGetProfile(context: context);
      _isSuccess = res[0];
      if (_isSuccess) {
        student = res[1] as Student;
      }

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const Spinner()
          : _isSuccess
              ? SizedBox(
                  width: double.infinity,
                  height: size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Container(
                              height: 110,
                              width: 120,
                              margin: const EdgeInsets.only(top: 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 10,
                                  ),
                                ],
                                image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/images/user.png",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              student.name,
                              style: const TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              "Student",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        flex: 7,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 24,
                              right: 24,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "PROFILE",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                listProfile(
                                  context,
                                  Icons.person_outline,
                                  "Full Name",
                                  student.name,
                                ),
                                listProfile(
                                  context,
                                  Icons.tag,
                                  "Roll number",
                                  student.rollNo,
                                ),
                                listProfile(
                                  context,
                                  Icons.tag,
                                  "Admission Number",
                                  student.admissionNo,
                                ),
                                listProfile(
                                  context,
                                  Icons.date_range_outlined,
                                  "Date of Birth",
                                  "${student.dob.day}-${student.dob.month}-${student.dob.year}",
                                ),
                                listProfile(
                                  context,
                                  Icons.factory_outlined,
                                  "Department",
                                  student.department,
                                ),
                                listProfile(
                                  context,
                                  Icons.email_outlined,
                                  "Email",
                                  student.email,
                                ),
                                listProfile(
                                  context,
                                  Icons.confirmation_number_outlined,
                                  "Joining Year",
                                  student.batchYear,
                                ),
                                listProfile(
                                    context,
                                    Icons.location_on_outlined,
                                    "Address",
                                    "${student.addressLine1} , ${student.addressLine2} , ${student.city} , ${student.state} , ${student.country}"),
                                listProfile(
                                  context,
                                  Icons.phone_outlined,
                                  "Phone Number",
                                  student.phoneNum,
                                ),
                                listProfile(
                                  context,
                                  Icons.person_outline,
                                  "Parent's Name",
                                  student.parentName,
                                ),
                                listProfile(
                                  context,
                                  Icons.phone_outlined,
                                  "Parent's Phone Number",
                                  student.parentPhoneNum,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : errorDisplay("Couldn't fetch profile"),
    );
  }
}
