import 'package:TicTacToe/start_screen.dart';
import 'package:TicTacToe/tictactoe.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class PlayerSelectionScreen extends StatefulWidget {
  const PlayerSelectionScreen({super.key});

  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  bool turnO = false;
  bool turnX = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
              colors: [Colors.white, Colors.blueAccent],
              radius: 0.75,
              focal: Alignment(0, -0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.14),
            const Text(
              'Choose Your Player',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.1),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          turnO = true;
                          turnX = false;
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              // Apply glow effect when it's Player 1's turn (turn0 == true)
                              if (turnO)
                                BoxShadow(
                                  color: Colors.greenAccent.withOpacity(0.8),
                                  blurRadius: 20.0,
                                  spreadRadius: 3.0,
                                ),
                            ],
                          ),
                          child: Image(
                            width: width * 0.4,
                            height: height * 0.2,
                            image:
                                const AssetImage("assets/images/player0.png"),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      const Text(
                        "Player 1",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          turnO = false;
                          turnX = true;
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              // Apply glow effect when it's Player 2's turn (turn0 == false)
                              if (turnX)
                                BoxShadow(
                                  color: Colors.greenAccent.withOpacity(0.8),
                                  blurRadius: 20.0,
                                  spreadRadius: 8.0,
                                ),
                            ],
                          ),
                          child: Image(
                            width: width * 0.35,
                            height: height * 0.2,
                            image:
                                const AssetImage("assets/images/playerX.png"),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      const Text(
                        "Player 2",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.1),
            ClipPath(
              clipper: CustomClipPath(),
              child: InkWell(
                onTap: () {
                  _navigateToGame();
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
                    "PLAY",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToGame() {
    // Navigate to the TicTacToe game screen and pass the selected player
    if (!turnO && !turnX) {
      const snackDemo = SnackBar(
        content: Text(
          'choose a player',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.amber,
        elevation: 10,
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackDemo);
    } else {
      String selected = (turnO) ? 'O' : 'X';
      Navigator.pushReplacement(
        context,
        PageTransition(
          alignment: Alignment.bottomCenter,
          curve: Curves.easeInOut,
          duration: const Duration(seconds: 1),
          reverseDuration: const Duration(seconds: 1),
          type: PageTransitionType.fade,
          child: HomePage(selectOption: selected),
        ),
      );
    }
  }
}
