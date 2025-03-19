import 'package:flutter/material.dart';

class SlidingWidget extends StatefulWidget {
  final bool isVisible;

  const SlidingWidget({Key? key, required this.isVisible}) : super(key: key);

  @override
  _SlidingWidgetState createState() => _SlidingWidgetState();
}

class _SlidingWidgetState extends State<SlidingWidget> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double halfScreenHeight = screenHeight / 4;

    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOutCubicEmphasized,
      bottom: widget.isVisible ? 0 : -halfScreenHeight,
      left: 0,
      right: 0,
      height: halfScreenHeight,
      child: Container(
        color: Colors.blueAccent,
        child: const Center(
          child: Text(
            'Sliding Widget',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
