import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/colors.dart';

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final Function func;
  const SocialIcon({Key key, @required this.iconSrc, @required this.func})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await func();
      },
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: mainColor,
              ),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              iconSrc,
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
    );
  }
}
