import 'dart:io';
import 'package:glycosafe_v1/components/recommendations.dart';
import "dart:math" as math;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
// class LabeledImage extends StatelessWidget {
//   late double width, height;
//   final VoidCallback onpressed;
//   final Uint8List? image;

//   LabeledImage({required this.onpressed, required this.image, Key? key})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return Stack(
//       children: [
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           height: height * 0.5,
//           child: SizedBox(
//             width: width,
//             child: Container(
//                 padding: const EdgeInsets.only(top: 20, bottom: 5),
//                 child: Image.memory(image!)),
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           height: height * 0.4,
//           child: InfoSection(),
//         )
//       ],
//     );
//   }
// }

// class InfoSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const ClipRRect(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//         child: Info());
//   }
// }

// class Info extends StatelessWidget {
//   const Info({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     return Container(
//       // padding: const EdgeInsets.only(top: 0, bottom: 15, left: 20, right: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               CircularProgress(
//                 nutrient: "Kcal",
//                 width: 100,
//                 progress: 0.75,
//                 calories: 1589,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   FoodCompositon(
//                       nutrient: "Carbohydrates", progress: 0.8, amount: 45),
//                   FoodCompositon(
//                       nutrient: "Proteins", progress: 0.4, amount: 45),
//                   FoodCompositon(nutrient: "Fat", progress: 0.2, amount: 45),
//                 ],
//               )
//             ],
//           ),
//           GlycemicAnalysis(threshold: appState.threshold, GI: 109),
//         ],
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
// class GlycemicAnalysis extends StatelessWidget {
//   int threshold;
//   late bool isDangerous;
//   int GI;

//   GlycemicAnalysis({super.key, required this.threshold, required this.GI});
//   Color? color;

//   @override
//   Widget build(BuildContext context) {
//     if (GI >= threshold) {
//       isDangerous = true;
//     } else {
//       isDangerous = false;
//     }

//     if (isDangerous) {
//       color = Colors.redAccent[700];
//     } else {
//       color = Colors.green;
//     }
//     return Container(
//       padding: const EdgeInsets.only(top: 10, left: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(children: [
//                 const TextSpan(
//                     text: "Your Meal's Glycemic Load is:",
//                     style: TextStyle(color: Colors.black)),
//                 const TextSpan(text: '\n\n'),
//                 TextSpan(
//                     text: "109",
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w800,
//                         color: color)),
//               ])),
//           Container(
//             // color: Colors.red,
//             decoration:
//                 BoxDecoration(border: Border.all(color: Colors.red, width: 2)),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: RichText(
//                   text: const TextSpan(children: [
//                 TextSpan(
//                     text: "GL Breakdown:",
//                     style: TextStyle(color: Colors.black)),
//                 TextSpan(text: '\n'),
//                 TextSpan(
//                     text: "Rice - 70 GL",
//                     style: TextStyle(fontSize: 13, color: Colors.black)),
//                 TextSpan(text: '\n'),
//                 TextSpan(
//                     text: "Beef - 0 GL",
//                     style: TextStyle(fontSize: 13, color: Colors.black)),
//                 TextSpan(text: '\n'),
//                 TextSpan(
//                     text: "Avocado - 39 GL",
//                     style: TextStyle(fontSize: 13, color: Colors.black))
//               ])),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
class CircularProgress extends StatelessWidget {
  double width, progress;
  double calories;
  String nutrient;
  Color color;

  CircularProgress(
      {super.key,
      required this.width,
      required this.nutrient,
      required this.calories,
      required this.color,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _circularPainter(progress: progress, color: color),
      child: SizedBox(
        height: width,
        width: width,
        child: Center(
            child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: calories.toStringAsFixed(2),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: width * 0.15),
            ),
            const TextSpan(text: "\n"),
            TextSpan(
              text: nutrient,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: width * 0.15),
            )
          ]),
        )),
      ),
    );
  }
}

class _circularPainter extends CustomPainter {
  double progress;
  Color color;

  _circularPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint greyPaint = Paint()
      ..strokeWidth = 6
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..strokeWidth = 6
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint acheivedPaint = Paint()
      ..strokeWidth = 6
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the grey background circle
    canvas.drawCircle(center, size.width / 2, greyPaint);

    // Draw the progress arc on top of the grey circle if progress is not 1
    if (progress < 1) {
      double sweepAngle = degreesToRadians(360 * progress);
      canvas.drawArc(
        Rect.fromCenter(center: center, width: size.width, height: size.height),
        degreesToRadians(-90),
        -sweepAngle,
        false,
        progressPaint,
      );
    } else {
      double sweeepAngle = 360;
      canvas.drawArc(
          Rect.fromCenter(
              center: center, width: size.width, height: size.height),
          degreesToRadians(90),
          sweeepAngle,
          false,
          acheivedPaint);
    }
  }

  double degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// ignore: must_be_immutable
class FoodCompositon extends StatelessWidget {
  String nutrient;
  int amount;
  double progress;

  FoodCompositon(
      {super.key,
      required this.nutrient,
      required this.progress,
      required this.amount});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nutrient,
          textAlign: TextAlign.left,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Container(
                  height: 10,
                  width: 100,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Colors.grey),
                ),
                Container(
                  height: 10,
                  width: 100 * progress,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Colors.blue),
                ),
              ],
            ),
            Text(" $amount g")
          ],
        )
      ],
    );
  }
}

class LabeledImageWidget extends StatefulWidget {
  final File image;
  final double aspectratio;
  final double width;
  final List foods;
  final List recommendations;
  final Map rankings;
  final Map status;
  final Map total_nutritional_facts;

  const LabeledImageWidget({
    Key? key,
    required this.status,
    required this.image,
    required this.aspectratio,
    required this.width,
    required this.foods,
    required this.recommendations,
    required this.rankings,
    required this.total_nutritional_facts,
  }) : super(key: key);

  @override
  State<LabeledImageWidget> createState() => _LabeledImageWidgetState();
}

class _LabeledImageWidgetState extends State<LabeledImageWidget> {
  @override
  void initState() {
    super.initState();

    // Show the bottom sheet after a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        showModalBottomSheet(
          isDismissible: false,
          showDragHandle: false,
          isScrollControlled: true,
          enableDrag: true,
          backgroundColor: const Color.fromARGB(37, 1, 218, 242),
          context: context,
          builder: (_) => Recommendations(
            width: widget.width,
            foods: widget.foods,
            recommendations: widget.recommendations,
            rankings: widget.rankings,
            status: widget.status,
            totalNutritionalFacts: widget.total_nutritional_facts,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectratio,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.file(
          widget.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
