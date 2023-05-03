import 'package:flutter/material.dart';

import '../../widgets/spinner.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          child: Column(
            children: const [
              Spinner(),
              SizedBox(height: 25),
              Text(
                "Loading...",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
