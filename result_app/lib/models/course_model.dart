import 'package:flutter/foundation.dart';

class Course with ChangeNotifier {
  final String id;
  final String name;
  final int semNo;
  final String offeredBy;
  final int hours;
  final String type;
  final int credits;
  final String facultyId;

  Course({
    @required this.id,
    @required this.name,
    @required this.semNo,
    @required this.offeredBy,
    @required this.hours,
    @required this.type,
    @required this.credits,
    @required this.facultyId,
  });
}
