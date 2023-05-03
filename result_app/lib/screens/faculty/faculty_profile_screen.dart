import 'package:flutter/material.dart';

import '../../api/faculty/faculty_get_profile.dart';

import '../../widgets/error_display.dart';
import '../../widgets/spinner.dart';
import '../../widgets/list_profile.dart';

import '../../models/faculty_model.dart';

class FacultyProfileScreen extends StatefulWidget {
  const FacultyProfileScreen({Key key}) : super(key: key);

  static const routeName = '/faculty-profile-screen';

  @override
  State<FacultyProfileScreen> createState() => _FacultyProfileScreenState();
}

class _FacultyProfileScreenState extends State<FacultyProfileScreen> {
  var _isLoading = true;
  var _isSuccess = false;

  Faculty faculty;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });

      var res = await facultyGetProfile(context: context);
      _isSuccess = res[0];
      if (_isSuccess) {
        faculty = res[1] as Faculty;
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
                              faculty.name,
                              style: const TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              "Faculty",
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
                                  faculty.name,
                                ),
                                listProfile(
                                  context,
                                  Icons.tag,
                                  "faculty Id",
                                  faculty.facultyId,
                                ),
                                listProfile(
                                  context,
                                  Icons.date_range_outlined,
                                  "Date of Birth",
                                  "${faculty.dob.day}-${faculty.dob.month}-${faculty.dob.year}",
                                ),
                                listProfile(
                                  context,
                                  Icons.email_outlined,
                                  "Email",
                                  faculty.email,
                                ),
                                listProfile(
                                  context,
                                  Icons.factory_outlined,
                                  "Department",
                                  faculty.department,
                                ),
                                listProfile(
                                  context,
                                  Icons.date_range_outlined,
                                  "Date of Joining",
                                  "${faculty.doj.day}-${faculty.doj.month}-${faculty.doj.year}",
                                ),
                                listProfile(
                                  context,
                                  Icons.location_on_outlined,
                                  "Address",
                                  "${faculty.addressLine1} , ${faculty.addressLine2} , ${faculty.city} , ${faculty.state} , ${faculty.country}",
                                ),
                                listProfile(
                                  context,
                                  Icons.phone_outlined,
                                  "Phone Number",
                                  faculty.phoneNum,
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
