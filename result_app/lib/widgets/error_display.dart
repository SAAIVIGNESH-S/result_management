import 'package:flutter/material.dart';

import '../helpers/colors.dart';

Widget errorDisplay(String error) {
  return Center(
    child: Text(
      error,
      style: TextStyle(
        fontSize: 18,
        color: mainColor,
      ),
    ),
  );
}
