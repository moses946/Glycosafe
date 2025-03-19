import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_svg/svg.dart";

class Final_SignUp extends StatelessWidget {
  const Final_SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.75;
    var height = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(children: [
            SvgPicture.asset(
              'assets/final_signup.svg',
              width: width,
              height: height,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "You are ready to go!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                  "Thank you for creating an account with us. Happy Snapping!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/camera");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(200, 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
