import 'package:flutter/foundation.dart';

class Faculty with ChangeNotifier {
  final String facultyId;
  final String name;
  final DateTime dob;
  final DateTime doj;
  final String department;
  final String email;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String country;
  final String phoneNum;

  Faculty({
    @required this.facultyId,
    @required this.name,
    @required this.dob,
    @required this.doj,
    @required this.department,
    @required this.email,
    @required this.addressLine1,
    @required this.addressLine2,
    @required this.city,
    @required this.state,
    @required this.country,
    @required this.phoneNum,
  });
}
