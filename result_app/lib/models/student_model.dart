import 'package:flutter/foundation.dart';

class Student with ChangeNotifier {
  final String rollNo;
  final String name;
  final String admissionNo;
  final DateTime dob;
  final String department;
  final String email;
  final String batchYear;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String country;
  final String phoneNum;
  final String parentName;
  final String parentPhoneNum;

  Student({
    @required this.rollNo,
    @required this.name,
    @required this.admissionNo,
    @required this.dob,
    @required this.department,
    @required this.email,
    @required this.batchYear,
    @required this.addressLine1,
    @required this.addressLine2,
    @required this.city,
    @required this.state,
    @required this.country,
    @required this.phoneNum,
    @required this.parentName,
    @required this.parentPhoneNum,
  });
}
