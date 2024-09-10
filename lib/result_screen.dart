import 'dart:math';

import 'package:TicTacToe/select_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.asset});

  final String asset;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 10));
    _confetti.play();
    FlameAudio.play("gameFinish.mp3", volume: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _confetti.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Stack(alignment: Alignment.topCenter, children: [
        Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
                colors: [Colors.white, Colors.blueAccent],
                radius: 0.9,
                focal: Alignment(0, -0.3)),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: height * 0.6,
              width: width,
              child: Image.asset(
                widget.asset,
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: height * 0.05),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    alignment: Alignment.bottomCenter,
                    curve: Curves.easeInOut,
                    duration: const Duration(seconds: 1),
                    reverseDuration: const Duration(seconds: 1),
                    type: PageTransitionType.fade,
                    child: const PlayerSelectionScreen(),
                  ),
                );
              },
              child: Container(
                height: height * 0.07,
                width: width * 0.35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  gradient: const LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                child: const Text(
                  "AGAIN",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
            InkWell(
              onTap: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: Container(
                height: height * 0.07,
                width: width * 0.35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  gradient: const LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                child: const Text(
                  "EXIT",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 60,
          child: ConfettiWidget(
            confettiController: _confetti,
            shouldLoop: true,
            numberOfParticles: 30,
            maxBlastForce: 30,
            gravity: 0.5,
            blastDirectionality: BlastDirectionality.explosive,
            colors: const [
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
            // manually specify the colors to be used
            createParticlePath: drawStar,
          ),
        ),
      ]),
    );
  }
}

/// A custom Path to paint stars.
Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
