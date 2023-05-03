import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';

import '../../models/progress_model.dart';

class StudentSubVisualizeScreen extends StatelessWidget {
  const StudentSubVisualizeScreen({Key key}) : super(key: key);

  static const routeName = '/student-subject-visualize-screen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Color> colors = [
      Colors.purple[100],
      Colors.purple[200],
      Colors.purple[300],
      Colors.purple[400],
      Colors.blueGrey[300],
      Colors.purple,
    ];
    Progress progress = ModalRoute.of(context).settings.arguments as Progress;
    var list = ["CAT 1", "CAT 2", "Assignment", "Sem", "Missed", "Lab"];
    var theoryValues = [
      progress.cat1 * 0.4,
      progress.cat2 * 0.4,
      progress.assignment,
      progress.sem * 0.4,
      100 -
          progress.cat1 * 0.4 -
          progress.cat2 * 0.4 -
          progress.assignment -
          progress.sem * 0.4,
    ];
    var embeddedValues = [
      progress.cat1 * 0.25,
      progress.cat2 * 0.25,
      progress.assignment * 0.5,
      progress.sem * 0.25,
      100 -
          progress.cat1 * 0.25 -
          progress.cat2 * 0.25 -
          progress.assignment * 0.5 -
          progress.sem * 0.25 -
          progress.lab * 0.4,
      progress.lab * 0.4,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('${progress.courseId} - ${progress.grade}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Attendance - ${progress.attendance}%"),
            SizedBox(
              height: size.height * 0.6,
              child: progress.courseType == 'embedded'
                  ? DChartPie(
                      data: [
                        {'domain': 'CAT 1', 'measure': embeddedValues[0]},
                        {'domain': 'CAT 2', 'measure': embeddedValues[1]},
                        {'domain': 'Assignment', 'measure': embeddedValues[2]},
                        {'domain': 'Sem', 'measure': embeddedValues[3]},
                        {'domain': 'Missed', 'measure': embeddedValues[4]},
                        {'domain': 'Lab', 'measure': embeddedValues[5]},
                      ],
                      fillColor: (pieData, index) => colors[index],
                      labelColor: Colors.black,
                      pieLabel: (pieData, index) =>
                          '${embeddedValues[index].toStringAsFixed(2)}%',
                      labelFontSize: 14,
                    )
                  : DChartPie(
                      data: [
                        {'domain': 'CAT 1', 'measure': theoryValues[0]},
                        {'domain': 'CAT 2', 'measure': theoryValues[1]},
                        {'domain': 'Assignment', 'measure': theoryValues[2]},
                        {'domain': 'Sem', 'measure': theoryValues[3]},
                        {'domain': 'Missed', 'measure': theoryValues[4]},
                      ],
                      fillColor: (pieData, index) => colors[index],
                      labelColor: Colors.black,
                      pieLabel: (pieData, index) =>
                          '${theoryValues[index].toStringAsFixed(2)}%',
                      labelFontSize: 14,
                    ),
            ),
            SizedBox(
              height: size.height * 0.2,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: size.width * 0.3,
                ),
                itemCount: progress.courseType == 'embedded'
                    ? list.length
                    : list.length - 1,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.square,
                        color: colors[index],
                      ),
                      Text(list[index]),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
