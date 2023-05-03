import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class StudentSGPAVisualizeScreen extends StatelessWidget {
  const StudentSGPAVisualizeScreen({Key key}) : super(key: key);

  static const routeName = '/student-sgpa-visualize-screen';

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments as List;
    List sgpa = arguments[0];
    var cgpa = arguments[1];

    List<Map<String, num>> data = [];
    for (int i = 0; i < sgpa.length; i++) {
      data.add(
        {'domain': i, 'measure': sgpa[i]},
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("CGPA - ${cgpa.toStringAsFixed(2)}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
        child: DChartLine(
          data: [
            {
              'id': 'Line',
              'data': data,
            },
          ],
          lineColor: (lineData, index, id) => Colors.purple,
          includePoints: true,
          lineWidth: 2,
        ),
      ),
    );
  }
}
