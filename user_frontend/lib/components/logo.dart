import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              const TextSpan(
                  text: "glyco",
                  style: TextStyle(color: Colors.black, fontSize: 25)),
              TextSpan(
                  text: "Safe",
                  style: TextStyle(
                      color: Colors.orange[600],
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
            ])),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
