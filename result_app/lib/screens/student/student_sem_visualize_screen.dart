import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:result_app/helpers/colors.dart';

import '../../models/progress_model.dart';

class StudentSemVisualizeScreen extends StatelessWidget {
  const StudentSemVisualizeScreen({Key key}) : super(key: key);

  static const routeName = '/student-sem-visualize-screen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List arguments = ModalRoute.of(context).settings.arguments as List;
    int semNo = arguments[0];
    List<Progress> progressList = arguments[1] as List<Progress>;
    var sgpa = arguments[2];

    List<Map<String, dynamic>> data = [];
    List grade = [];

    for (var subject in progressList) {
      grade.add(subject.grade);

      var marks = subject.courseType == 'embedded'
          ? subject.cat1 * 0.25 +
              subject.cat2 * 0.25 +
              subject.assignment * 0.5 +
              subject.sem * 0.25 +
              subject.lab * 0.4
          : subject.cat1 * 0.4 +
              subject.cat2 * 0.4 +
              subject.assignment +
              subject.sem * 0.4;

      data.add({'domain': subject.courseId, 'measure': marks});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Semester $semNo - ${sgpa.toStringAsFixed(2)}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height * 0.8,
            child: DChartBar(
              data: [
                {
                  'id': 'Bar',
                  'data': data,
                },
              ],
              domainLabelPaddingToAxisLine: 15,
              measureLabelPaddingToAxisLine: 15,
              axisLineTick: 2,
              axisLinePointTick: 5,
              axisLinePointWidth: 5,
              minimumPaddingBetweenLabel: 5,
              axisLineColor: Colors.green,
              barColor: (barData, index, id) => Colors.purple[400],
              showBarValue: true,
              barValue: (barData, index) =>
                  '   ${data[index]["measure"]} - ${grade[index]}',
              barValueColor: Colors.white,
              barValuePosition: BarValuePosition.inside,
              measureMin: 0,
              measureMax: 100,
              verticalDirection: false,
              domainLabelColor: mainColor,
              domainAxisTitleFontSize: 14,
              domainLabelFontSize: 14,
              measureAxisTitleColor: mainColor,
              measureLabelFontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
