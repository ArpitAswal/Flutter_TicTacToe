import 'package:TicTacToe/select_screen.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  var time = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeBGM();
  }

  // Initialize BGM globally so it's only initialized once
  static void _initializeBGM() {
    FlameAudio.bgm.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    FlameAudio.bgm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () {
            DateTime now = DateTime.now();
            if (now.difference(time) > const Duration(seconds: 3)) {
              //add duration of press gap
              time = now;
              Fluttertoast.showToast(
                  msg: "Tap again to exit",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
              return Future.value(false);
            }

            return Future.value(true);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                      colors: [Colors.white, Colors.blueAccent],
                      radius: 0.75,
                      focal: Alignment(0, -0.5)),
                ),
              ),
              const Align(
                alignment: Alignment(0, -0.5),
                child: SizedBox(
                  child: Image(
                    image: AssetImage("assets/images/Logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.5),
                child: ClipPath(
                  clipper: CustomClipPath(),
                  child: InkWell(
                    onTap: () {
                      navigate(context);
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      child: const Text(
                        "START",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigate(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        alignment: Alignment.bottomCenter,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 700),
        reverseDuration: const Duration(milliseconds: 700),
        type: PageTransitionType.rightToLeftWithFade,
        child: const PlayerSelectionScreen(),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(10, 0);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
