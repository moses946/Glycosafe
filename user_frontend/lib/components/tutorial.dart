// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class Tutorials extends StatefulWidget {
  @override
  _tutorialState createState() => _tutorialState();
}

class _tutorialState extends State<Tutorials> {
  int _currentPage = 0;
  List<Widget> _tutorialPages = [];

  @override
  void initState() {
    super.initState();
    _tutorialPages = [
      firstTutorial(onNext: onNext),
      secondTutorial(onNext: onNext, onBack: onBack),
      thirdTutorial(
        onNext: onNext,
        onBack: onBack,
      ),
      lastTutorial(onBack: onBack)
    ];
  }

  void onNext() {
    if (_currentPage < _tutorialPages.length - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void onBack() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 70),
      child: _tutorialPages[_currentPage],
    );
  }
}

class firstTutorial extends StatelessWidget {
  final VoidCallback onNext;
  const firstTutorial({super.key, required this.onNext});
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
              text: "How to use\n",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
              children: [
                TextSpan(
                    text: "GlycoSafe",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange))
              ]),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 0.35,
          child: Image.asset('assets/images/tutorial_food.jpg'),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Make sure the food you are about to snap is centered within the guidelines.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            onNext();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            // onPrimary: Colors.white,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Next",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class secondTutorial extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const secondTutorial({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
              text: "How to use\n",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
              children: [
                TextSpan(
                    text: "GlycoSafe",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange))
              ]),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white.withAlpha(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                const Text(
                  "👇👇",
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.white.withAlpha(100),
                )
              ]),
              Icon(
                Icons.circle_outlined,
                size: 100,
                color: Colors.white.withAlpha(100),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        const Text(
          "Optionally, you can upload a photo taken earlier from the gallery.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            onNext();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            // onPrimary: Colors.white,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Next",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            onBack();
          },
          child: const Text(
            "back",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class thirdTutorial extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const thirdTutorial({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
              text: "How to use\n",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
              children: [
                TextSpan(
                    text: "GlycoSafe",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange))
              ]),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 0.35,
          child: Image.asset('assets/images/tutorial.JPG'),
        ),
        const SizedBox(
          height: 40,
        ),
        const Text(
          "Send the image to our servers and if the segments are okay, wait for your meal analysis.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            onNext();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            // onPrimary: Colors.white,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Next",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            onBack();
          },
          child: const Text(
            "back",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class lastTutorial extends StatelessWidget {
  final VoidCallback onBack;
  const lastTutorial({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
              text: "How to use\n",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
              children: [
                TextSpan(
                    text: "GlycoSafe",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange))
              ]),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70,
                height: 50,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.orange),
                child: const Center(
                  child: Icon(
                    Icons.bookmark,
                    color: Colors.green,
                    size: 25,
                  ),
                ),
              ),
              Container(
                width: 70,
                height: 50,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.orange),
                child: const Center(
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 70,
        ),
        const ListTile(
          leading: Icon(
            Icons.bookmark,
            color: Colors.green,
            size: 30,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
              "If you are satisfied with the meal analysis, log the meal to your diary.",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        const SizedBox(
          height: 20,
        ),
        const ListTile(
          leading: Icon(
            Icons.delete_outline_rounded,
            color: Colors.red,
            size: 30,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
              "You can choose to discard the meal  if you will not eat it.",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            // onPrimary: Colors.white,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Finish",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            onBack();
          },
          child: const Text(
            "back",
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.orange,
              decorationStyle: TextDecorationStyle.solid,
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
