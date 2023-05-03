import 'package:flutter/foundation.dart';

class Enrollment with ChangeNotifier {
  final String batchYear;
  final String dept;
  final String courseId;
  final String courseName;
  final String courseType;
  final String facId;
  final int sem;
  final bool isCompleted;

  Enrollment({
    @required this.batchYear,
    @required this.dept,
    @required this.courseId,
    @required this.courseName,
    @required this.courseType,
    @required this.facId,
    @required this.sem,
    @required this.isCompleted,
  });
}
