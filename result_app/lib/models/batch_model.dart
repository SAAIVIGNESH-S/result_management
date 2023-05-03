import 'package:flutter/foundation.dart';

class Batch with ChangeNotifier {
  final String batchYear;
  final String dept;
  final int currentSem;
  final List students;
  final List currentCourses;

  Batch({
    @required this.batchYear,
    @required this.dept,
    @required this.currentSem,
    @required this.students,
    @required this.currentCourses,
  });
}
