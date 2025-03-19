import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glycosafe_v1/components/loading_dots.dart';
import 'package:glycosafe_v1/components/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.microtask(() {
      Future.delayed(const Duration(seconds: 4), () {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/glyco-logo.jpg")),
            Logo(),
            LoadingDots()
          ],
        ),
      ),
    );
  }
}
