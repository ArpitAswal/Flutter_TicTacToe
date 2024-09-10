import 'package:TicTacToe/result_screen.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.selectOption});

  final String selectOption;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool turn0 = true;
  List<String> elements = ['', '', '', '', '', '', '', '', ''];
  bool isWinner = false;
  int score0 = 0;
  int scoreX = 0;
  int filledIndex = 0;
  bool bgmPlaying = false;
  bool muteVolume = false;
  late String asset;
  late var state;

  final isFabOpen = ValueNotifier(false);
  final _key = GlobalKey<ExpandableFabState>();

  final List<List<int>> winningCombinations = [
    [0, 1, 2], // Row 1
    [3, 4, 5], // Row 2
    [6, 7, 8], // Row 3
    [0, 3, 6], // Column 1
    [1, 4, 7], // Column 2
    [2, 5, 8], // Column 3
    [0, 4, 8], // Diagonal 1
    [2, 4, 6] // Diagonal 2
  ];

  @override
  void initState() {
    super.initState();
    turn0 = widget.selectOption == 'O';
    _playBackgroundAudio(); // Play the game audio when screen starts
  }

  @override
  void dispose() {
    _stopBackgroundAudio();
    super.dispose();
  }

  void _playBackgroundAudio() async {
    _loadScore();
    if (!bgmPlaying) {
      await FlameAudio.bgm.play("backgroundSound.mp3", volume: 0.5);
      bgmPlaying = true;
    }
  }

  void _stopBackgroundAudio() async {
    _saveScore();
    if (bgmPlaying) {
      await FlameAudio.bgm.stop();
      bgmPlaying = false;
    }
  }

  void _playClickSound() async {
    if (!muteVolume) {
      await FlameAudio.play("tapSound.mp3", volume: 1);
    }
  }

  void _saveScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('score0', score0);
    prefs.setInt('scoreX', scoreX);
  }

  void _loadScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    score0 = prefs.getInt('score0') ?? 0;
    scoreX = prefs.getInt('scoreX') ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    double cellSize = MediaQuery.of(context).size.width / 3 - 16;

    return WillPopScope(
      onWillPop: () async {
        if (isFabOpen.value) {
          isFabOpen.value = false;
          if(state != null){
            state.toggle();
          }
          return false;
        }
        return true;
      },
      child: Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: ExpandableFab(
            key: _key,
            duration: const Duration(milliseconds: 500),
            distance: 80.0,
            type: ExpandableFabType.fan,
            childrenAnimation: ExpandableFabAnimation.rotate,
            overlayStyle: ExpandableFabOverlayStyle(
              color: Colors.black.withOpacity(0.5),
              blur: 5,
            ),
            onOpen: () {
              isFabOpen.value = true;
              state = _key.currentState;
            },
            openButtonBuilder: DefaultFloatingActionButtonBuilder(
              backgroundColor: Colors.amber,
              shape: const CircleBorder(side: BorderSide(color: Colors.black, width: 1.2)),
              child: const Icon(
                Icons.read_more,
              ),
            ),
            closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                backgroundColor: Colors.amber,
                shape:
                    const CircleBorder(side: BorderSide(color: Colors.black, width: 1.2)),
                child: const Icon(
                  Icons.close,
                )),
            children: [
              FloatingActionButton.small(
                shape: const CircleBorder(side: BorderSide(color: Colors.black, width: 1.2)),
                heroTag: null,
                backgroundColor: Colors.amber,
                child: const Icon(Icons.restart_alt_rounded),
                onPressed: () {
                  _clearBoard();
                  state = _key.currentState;
                  if (state != null) {
                    state.toggle();
                  }
                },
              ),
              FloatingActionButton.small(
                shape: const CircleBorder(side: BorderSide(color: Colors.black, width: 1.2)),
                heroTag: null,
                backgroundColor: Colors.amber,
                child: const Icon(Icons.scoreboard_rounded),
                onPressed: () {
                  setState(() {
                    score0 = 0;
                    scoreX = 0;
                    _saveScore();
                    _clearBoard();
                    state = _key.currentState;
                    if (state != null) {
                      state.toggle();
                    }
                  });
                },
              ),
              FloatingActionButton.small(
                shape: const CircleBorder(side: BorderSide(color: Colors.black, width: 1.2)),
                heroTag: null,
                backgroundColor: Colors.amber,
                child: Icon((muteVolume) ? Icons.volume_mute : Icons.volume_up),
                onPressed: () {
                  muteVolume = !muteVolume;
                  if (muteVolume) {
                    FlameAudio.bgm.audioPlayer.setVolume(0.0);
                  } else {
                    FlameAudio.bgm.audioPlayer.setVolume(1.0);
                  }
                  state = _key.currentState;
                  if (state != null) {
                    state.toggle();
                  }
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
                colors: [Colors.white, Colors.blueAccent],
                radius: 0.9,
                focal: Alignment(0, -0.3)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.034,
              ),
              Container(
                height: height * 0.06,
                width: width * 0.32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.2),
                      left: BorderSide(color: Colors.black, width: 1.2),
                      right: BorderSide(color: Colors.black, width: 1.2)),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(21),
                  ),
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                child: Text(
                  "$score0 x $scoreX",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              // Apply glow effect when it's Player 1's turn (turn0 == true)
                              if (turn0)
                                BoxShadow(
                                  color: Colors.greenAccent.withOpacity(0.8),
                                  blurRadius: 20.0,
                                  spreadRadius: 2.0,
                                ),
                            ],
                          ),
                          child: Image(
                            width: width * 0.2,
                            height: height * 0.1,
                            image:
                                const AssetImage("assets/images/player0.png"),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(height: 8.0),
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
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              // Apply glow effect when it's Player 2's turn (turn0 == false)
                              if (!turn0)
                                BoxShadow(
                                  color: Colors.greenAccent.withOpacity(0.8),
                                  blurRadius: 20.0,
                                  spreadRadius: 3.0,
                                ),
                            ],
                          ),
                          child: Image(
                            width: width * 0.2,
                            height: height * 0.1,
                            image:
                                const AssetImage("assets/images/playerX.png"),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(height: 8.0),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              _tapped(index);
                              _playClickSound();
                            },
                            child: Container(
                                width: cellSize,
                                height: cellSize,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(145, 215, 253, 1.0),
                                  borderRadius: BorderRadius.circular(21),
                                  border: const Border(
                                    left: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 4.0, color: Colors.black),
                                    top: BorderSide(
                                        width: 2.0, color: Colors.black),
                                    right: BorderSide(
                                        width: 2.0, color: Colors.black),
                                  ),
                                ),
                                padding: const EdgeInsets.all(6.0),
                                child: (elements[index].isEmpty)
                                    ? const Text("")
                                    : Image.asset(
                                        (elements[index] == 'O')
                                            ? 'assets/images/player0.png'
                                            : 'assets/images/playerX.png',
                                        fit: BoxFit.contain,
                                      )));
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (turn0 && elements[index] == '') {
        elements[index] = 'O';
        filledIndex++;
        turn0 = !turn0;
      } else if (!turn0 && elements[index] == '') {
        elements[index] = 'X';
        filledIndex++;
        turn0 = !turn0;
      } else if (elements[index] != '') {
        turn0 = turn0;
      }
      _checkWinner();
    });
  }

  void _checkWinner() {
    for (var combo in winningCombinations) {
      if (elements[combo[0]] == elements[combo[1]] &&
          elements[combo[0]] == elements[combo[2]] &&
          elements[combo[0]] != '') {
        _result(elements[combo[0]]);
        return;
      }
    }

    // Check for a draw
    if (filledIndex == 9) {
      _result('draw');
    }
  }

  void _result(String winner) {
    _stopBackgroundAudio();
    if (winner == 'O') {
      score0++;
      asset = "assets/images/Winner1.png";
    } else if (winner == 'X') {
      scoreX++;
      asset = "assets/images/Winner2.png";
    } else {
      asset = "assets/images/Draw.png";
    }
    navigate(asset);
  }

  void _clearBoard() {
    for (int i = 0; i < 9; i++) {
      elements[i] = '';
    }
    filledIndex = 0;
    setState(() {});
  }

  void navigate(String asset) {
    Navigator.pushReplacement(
      context,
      PageTransition(
        alignment: Alignment.bottomCenter,
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
        reverseDuration: const Duration(seconds: 1),
        type: PageTransitionType.fade,
        child: ResultScreen(asset: asset),
      ),
    );
  }
}
