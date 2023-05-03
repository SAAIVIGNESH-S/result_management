import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/colors.dart';

import '../../providers/data.dart';
import '../../widgets/faculty/faculty_app_drawer.dart';

class FacultyHomeScreen extends StatelessWidget {
  const FacultyHomeScreen({Key key}) : super(key: key);

  static const routeName = '/faculty-home-screen';

  @override
  Widget build(BuildContext context) {
    Data data = Provider.of<Data>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: mainColor,
      ),
      drawer: const FacultyAppDrawer(),
      body: Container(
        padding: const EdgeInsets.only(top: 50),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/login.svg",
                height: size.height * 0.4,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Acad",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Logged In As ${data.getRole.toUpperCase()}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
