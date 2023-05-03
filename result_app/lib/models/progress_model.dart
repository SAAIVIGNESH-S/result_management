import 'package:flutter/foundation.dart';

class Progress with ChangeNotifier {
  final String courseId;
  final String courseType;
  final int cat1;
  final int cat2;
  final int assignment;
  final int attendance;
  final int lab;
  final int sem;
  final String grade;

  Progress({
    @required this.courseId,
    @required this.courseType,
    @required this.cat1,
    @required this.cat2,
    @required this.assignment,
    @required this.attendance,
    @required this.lab,
    @required this.sem,
    @required this.grade,
  });
}
