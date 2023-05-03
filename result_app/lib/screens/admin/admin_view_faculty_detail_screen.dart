import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/faculty_model.dart';

class AdminViewFacultyDetailScreen extends StatefulWidget {
  const AdminViewFacultyDetailScreen({Key key}) : super(key: key);

  static const routeName = '/admin-view-faculty-detail-screen';

  @override
  State<AdminViewFacultyDetailScreen> createState() =>
      _AdminViewFacultyDetailScreenState();
}

class _AdminViewFacultyDetailScreenState
    extends State<AdminViewFacultyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Faculty faculty = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(faculty.facultyId),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 100,
                child: Image.asset("assets/images/user.png"),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Name"),
                  Text(faculty.name),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Email"),
                  Text(faculty.email),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Department"),
                  Text(faculty.department),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("DOB"),
                  Text(
                    DateFormat('dd/MM/yyyy').format(faculty.dob),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Phone"),
                  Text(faculty.phoneNum),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("DOJ"),
                  Text(
                    DateFormat('dd/MM/yyyy').format(faculty.doj),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Address"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity - 40,
                child: Center(
                  child: Text(
                    "${faculty.addressLine1}, ${faculty.addressLine2}, ${faculty.city}, ${faculty.state}, ${faculty.country}",
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
