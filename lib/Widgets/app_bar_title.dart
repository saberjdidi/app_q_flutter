
import 'package:flutter/material.dart';

import '../Utils/custom_colors.dart';

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 65,
          width: 100,
        ),
        SizedBox(width: 7),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Mobile',
            style: TextStyle(
              color: CustomColors.blueAccent,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}