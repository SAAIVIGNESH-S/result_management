import 'package:flutter/material.dart';

Widget listProfile(
    BuildContext context, IconData icon, String text1, String text2) {
  Size size = MediaQuery.of(context).size;
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(
          width: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text1,
              style: const TextStyle(
                color: Colors.black87,
                fontFamily: "Montserrat",
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: size.width * 0.7,
              child: Text(
                text2,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
