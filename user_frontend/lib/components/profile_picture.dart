import 'dart:math';

import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String firstName;

  const ProfilePicture({super.key, required this.firstName});

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(constraints.maxWidth, constraints.maxHeight);
        double fontSize = size / 2.5;

        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(198, 168, 62, 1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              firstName[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
