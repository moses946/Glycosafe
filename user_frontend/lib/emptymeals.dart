import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NoFoodsBody extends StatelessWidget {
  const NoFoodsBody({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/login_svg.svg',
            width: width * 0.5,
            height: width * 0.6,
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "No food logged on this date",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey[800]),
              ))
        ],
      ),
    );
  }
}
