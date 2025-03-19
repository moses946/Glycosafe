import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  _LoadingDotsState createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _dot1Color;
  late Animation<Color?> _dot2Color;
  late Animation<Color?> _dot3Color;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _dot1Color = ColorTween(
      begin: Colors.orange,
      end: Colors.orange,
    ).animate(_controller);

    _dot2Color = ((ColorTween(
      begin: Colors.grey[300],
      end: Colors.orange,
    ).animate(_controller)
      ..addListener(() {
        if (_dot2Color.value == Colors.orange) {
          _controller.forward();
        }
      })));
    _dot3Color = ((ColorTween(
      begin: Colors.grey[300],
      end: Colors.orange,
    ).animate(_controller)
      ..addListener(() {
        if (_dot3Color.value == Colors.orange) {
          _controller.forward();
        }
      })));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _dot1Color,
          builder: (context, child) {
            return Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dot1Color.value,
              ),
            );
          },
        ),
        const SizedBox(width: 5),
        AnimatedBuilder(
          animation: _dot2Color,
          builder: (context, child) {
            return Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dot2Color.value,
              ),
            );
          },
        ),
        const SizedBox(width: 5),
        AnimatedBuilder(
          animation: _dot3Color,
          builder: (context, child) {
            return Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dot3Color.value,
              ),
            );
          },
        ),
      ],
    );
  }
}
