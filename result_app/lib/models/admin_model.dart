import 'package:flutter/foundation.dart';

class Admin with ChangeNotifier {
  final String adminId;
  final String name;
  final DateTime dob;
  final String email;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String country;
  final String phoneNum;

  Admin({
    @required this.adminId,
    @required this.name,
    @required this.dob,
    @required this.email,
    @required this.addressLine1,
    @required this.addressLine2,
    @required this.city,
    @required this.state,
    @required this.country,
    @required this.phoneNum,
  });
}
