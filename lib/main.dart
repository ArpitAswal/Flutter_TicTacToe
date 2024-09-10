import 'package:TicTacToe/start_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSplashScreen(
          splash: Lottie.asset('assets/Lottie/Animation - 1725697452303.json',
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.3,
              alignment: Alignment.center,
              animate: true,
              backgroundLoading: true,
              fit: BoxFit.cover,
              frameRate: FrameRate.max,
              filterQuality: FilterQuality.high,
              reverse: true),
          nextScreen: const StartScreen(),
          splashTransition: SplashTransition.sizeTransition,
          pageTransitionType: PageTransitionType.fade,
          curve: Curves.elasticInOut,
          centered: true,
          duration: 6000,
          backgroundColor: const Color.fromRGBO(0, 0, 0, 1.0)),
    );
  }
}
