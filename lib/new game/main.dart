import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/new%20game/block_table.dart';
import 'package:play_pointz/new%20game/coordinate.dart';

import 'package:play_pointz/new%20game/game_table.dart';
import 'package:play_pointz/new%20game/men.dart';
import 'dart:math';

class MyGamePage extends StatefulWidget {
  final Color colorBackgroundF = Color(0xffeec295);
  final Color colorBackgroundT = Color(0xff9a6851);
  final Color colorBorderTable = Color(0xff6d3935);
  final Color colorAppBar = Color(0xff6d3935);
  final Color colorBackgroundGame = AppColors.PRIMARY_COLOR;
  final Color colorBackgroundHighlight = Colors.blue[500];
  final Color colorBackgroundHighlightAfterKilling = AppColors.PRIMARY_COLOR;

  MyGamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit Game'),
            content: Text('Are you sure you want to exit the game?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    initGame();
                    whiteside = 0;
                    blackside = 0;
                  });
                  navigator.pop();
                },
                child: Text('Refesh'),
              ),
            ],
          ),
        )) ??
        false;
  }

  GameTable gameTable;
  int modeWalking;

  double blockSize = 1;

  @override
  void initState() {
    initGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
    super.initState();
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome!'),
          content: Text(
              'PlayPointz හදුන්වා දෙන Digital දාම් බෝඩ් එකෙන් ඔයා කැමති කෙනෙක් එක්ක Play  කරන්න පුළුවන් ඒත් ඔයාට මේ Game එකෙන් Pointz Earn කරන්න අවස්ථාව ලැබෙන්නේ නෑ ඒ කොහොම උනත් Fun එකක් ගන්න ඔයත් Try කරල බලන්න'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void initGame() {
    modeWalking = GameTable.MODE_WALK_NORMAL;
    gameTable = GameTable(countRow: 8, countCol: 8);
    gameTable.initMenOnTable();

    // For test
//    gameTable.currentPlayerTurn = 2;
//    gameTable.addMen(Coordinate(row: 0, col: 7), player: 2, isKing: true);
//    gameTable.addMen(Coordinate(row: 2, col: 5), player: 1);
//    gameTable.addMen(Coordinate(row: 4, col: 5), player: 1, isKing: true);
//    gameTable.addMen(Coordinate(row: 6, col: 5), player: 1);
//    gameTable.addMen(Coordinate(row: 4, col: 1), player: 1, isKing: true);
//    gameTable.addMen(Coordinate(row: 1, col: 2), player: 1);
//    gameTable.addMen(Coordinate(row: 1, col: 4), player: 1);
//    gameTable.addMen(Coordinate(row: 3, col: 6), player: 1);
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
              body: Container(
                  color: widget.colorBackgroundGame,
                  child: Column(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: widget.colorAppBar,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 3),
                                blurRadius: 12)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[buildCurrentPlayerTurn1()],
                      ),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Transform.rotate(
                            angle: (180 * pi / 180),
                            child: Text(
                              "PlayPointz",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.2),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (int i = 0; i < blackside; i++)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Center(
                          child: buildGameTable(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (int i = 0; i < whiteside; i++)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "PlayPointz",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.2),
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                    Container(
                      decoration: BoxDecoration(
                          color: widget.colorAppBar,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 3),
                                blurRadius: 12)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[buildCurrentPlayerTurn()],
                      ),
                    ),
                  ]))),
        ),
      ),
    );
  }

  void initScreenSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    if (width < height) {
      blockSize = (shortestSide / 8) - (shortestSide * 0.03);
    } else {
      blockSize = (shortestSide / 8) - (shortestSide * 0.05);
    }
  }

  buildGameTable() {
    List<Widget> listCol = List();
    for (int row = 0; row < gameTable.countRow; row++) {
      List<Widget> listRow = List();
      for (int col = 0; col < gameTable.countCol; col++) {
        listRow.add(buildBlockContainer(Coordinate(row: row, col: col)));
      }

      listCol.add(Row(mainAxisSize: MainAxisSize.min, children: listRow));
    }

    return Container(
        padding: EdgeInsets.all(8),
        color: widget.colorBorderTable,
        child: Column(mainAxisSize: MainAxisSize.min, children: listCol));
  }

  int whiteside = 0;
  int blackside = 0;

  Widget buildBlockContainer(Coordinate coor) {
    BlockTable block = gameTable.getBlockTable(coor);

    Color colorBackground;
    if (block.isHighlight) {
      colorBackground = widget.colorBackgroundHighlight;
    } else if (block.isHighlightAfterKilling) {
      colorBackground = widget.colorBackgroundHighlightAfterKilling;
    } else {
      if (gameTable.isBlockTypeF(coor)) {
        colorBackground = widget.colorBackgroundF;
      } else {
        colorBackground = widget.colorBackgroundT;
      }
    }

    Widget menWidget;
    if (block.men != null) {
      Men men = gameTable.getBlockTable(coor).men;

      menWidget = Center(
          child: buildMenWidget(
              player: men.player, isKing: men.isKing, size: blockSize));

      if (men.player == gameTable.currentPlayerTurn) {
        menWidget = Draggable<Men>(
            child: menWidget,
            feedback: menWidget,
            childWhenDragging: Container(),
            data: men,
            onDragStarted: () {
              setState(() {
                print("walking mode = ${modeWalking}");
                gameTable.highlightWalkable(men, mode: modeWalking);
              });
            },
            onDragEnd: (details) {
              setState(() {
                gameTable.clearHighlightWalkable();
              });
            });
      }
    } else {
      menWidget = Container();
    }

    if (!gameTable.hasMen(coor) && !gameTable.isBlockTypeF(coor)) {
      return DragTarget<Men>(builder: (context, candidateData, rejectedData) {
        return buildBlockTableContainer(colorBackground, menWidget);
      }, onWillAccept: (men) {
        BlockTable blockTable = gameTable.getBlockTable(coor);
        return blockTable.isHighlight || blockTable.isHighlightAfterKilling;
      }, onAccept: (men) {
        print("onAccept");

        final audio = AudioPlayer();
        audio.play(AssetSource("audio/Chess_Sound.mp3"));
        setState(() {
          gameTable.moveMen(men, Coordinate.of(coor));
          gameTable.checkKilled(coor);
          bool wasKilled = gameTable.checkKilled(coor);

          if (wasKilled) {
            if (men.player == 1) {
              blackside++;
              if (blackside == 12) {
                final audio = AudioPlayer();
                audio.play(AssetSource("audio/winingsound.wav"));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('සුබ පැතුම්!'),
                      content: Text('කලු ඉත්තන් ජයග්‍රහණය  කරන ලදි'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            setState(() {
                              initGame();
                              blackside = 0;
                              whiteside = 0;
                            });
                            navigator.pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              Logger().i("black side  : " + blackside.toString());
            } else {
              whiteside++;
              if (whiteside == 12) {
                final audio = AudioPlayer();
                audio.play(AssetSource("audio/winingsound.wav"));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('සුබ පැතුම්!'),
                      content: Text('සුදු ඉත්තන් ජයග්‍රහණය  කරන ලදි'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            setState(() {
                              blackside = 0;
                              whiteside = 0;
                              initGame();
                            });

                            navigator.pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }

              Logger().i("white side  : " + whiteside.toString());
            }
          }
          if (gameTable.checkKillableMore(men, coor)) {
            modeWalking = GameTable.MODE_WALK_AFTER_KILLING;
          } else {
            if (gameTable.isKingArea(
                player: gameTable.currentPlayerTurn, coor: coor)) {
              men.upgradeToKing();
            }
            modeWalking = GameTable.MODE_WALK_NORMAL;
            gameTable.clearHighlightWalkable();
            gameTable.togglePlayerTurn();
          }
        });
      });
    }

    return buildBlockTableContainer(colorBackground, menWidget);
  }

  Widget buildBlockTableContainer(Color colorBackground, Widget menWidget) {
    Widget containerBackground = Container(
        width: blockSize + (blockSize * 0.1),
        height: blockSize + (blockSize * 0.1),
        color: colorBackground,
        margin: EdgeInsets.all(2),
        child: menWidget);
    return containerBackground;
  }

  Widget buildCurrentPlayerTurn() {
    return Container(
      height: MediaQuery.of(context).size.width / 2 * 0.55,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        gameTable.currentPlayerTurn == 2
            ? Text("Your turn".toUpperCase(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
            : Container(),
        Text(
          '© POWERD BY PLAYPOINTZ',
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
        SizedBox(
          height: 5,
        )
      ]),
    );
  }

  Widget buildCurrentPlayerTurn1() {
    return Container(
      height: MediaQuery.of(context).size.width / 2 * 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    BackButton(
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Transform.rotate(
                      angle: (180 * pi / 180),
                      child: Text(
                        '© POWERD BY PLAYPOINTZ',
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                gameTable.currentPlayerTurn == 1
                    ? Transform.rotate(
                        angle: (180 * pi / 180),
                        child: Text("Your turn".toUpperCase(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      )
                    : Container(),
              ])
        ],
      ),
    );
  }

  buildMenWidget({int player = 1, bool isKing = false, double size = 32}) {
    if (isKing) {
      return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)
              ],
              color: player == 1 ? Colors.black54 : Colors.grey[100]),
          child: Icon(Icons.star,
              color: player == 1
                  ? Colors.grey[100].withOpacity(0.5)
                  : Colors.black54.withOpacity(0.5),
              size: size - (size * 0.1)));
    }

    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)
            ],
            color: player == 1 ? Colors.black54 : Colors.grey[100]));
  }
}
