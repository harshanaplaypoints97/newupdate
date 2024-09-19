import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/play/game_token.dart';
import 'package:play_pointz/models/play/play_section_data.dart';
import 'package:play_pointz/new%20game/main.dart';
import 'package:play_pointz/screens/feed/feed_page.dart';
import 'package:play_pointz/screens/google_ads/inline_adaptive_banner_ads.dart';
import 'package:play_pointz/screens/google_ads/store_banner_ad.dart';
import 'package:play_pointz/screens/play/game_screen/web_game_view.dart';
import 'package:play_pointz/screens/play/quiz_games.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';
import 'package:provider/provider.dart';

import '../../Provider/darkModd.dart';
import '../../constants/app_colors.dart';

class PlayPage extends StatefulWidget {
  final VoidCallback cointBalanceUpdater;
  const PlayPage({Key key, this.cointBalanceUpdater}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  bool buttonLoading = false;
  bool adLoaded = false;
  bool adFailedToLoad = false;
  CoinBalanceController coinBalanceController;
  final userController = Get.put(UserController());
  PlaySectionData _playSectionData;
  String current = '';

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  @override
  void initState() {
    _createInterstitialAd();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    getPlaySectionData();
    super.initState();
  }

  void returnCallBack() {
    setState(() {
      coinBalanceController.onInit();
    });
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? admobAppIdInterstitialAndroid
            : admobAppIdInterstitialIOS,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            setState(() {
              adLoaded = true;
              adFailedToLoad = false;
            });
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            } else {
              setState(() {
                adLoaded = false;
                adFailedToLoad = true;
              });
            }
          },
        ));
  }

  void _showInterstitialAd(
      {BuildContext context, PlaySectionData snapshot, int index}) {
    if (_interstitialAd == null) {
      setState(() {
        buttonLoading = false;
        snapshot.body[index].loading = false;
      });
      return;
    }
    ShowLoadingPopUp(context);
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        InterstitialAdResponse(
            context: context, snapshot: snapshot, index: index);
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        InterstitialAdResponse(
            context: context, snapshot: snapshot, index: index);
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  void ShowLoadingPopUp(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void pointDeductionPopup(BuildContext context, int points, String gameName,
      PlaySectionData snapshot, int index, String gameToken) {
    switch (gameName) {
      case "Speed Over Water":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/popups/game_popups/speed-over-water/ready.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: MediaQuery.of(context).size.width * 0.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => WebGameView(
                                            gameData: snapshot.body[index],
                                            callBack: () => {setState(() {})},
                                            coinBalanceController:
                                                coinBalanceController,
                                            gameUrl:
                                                "${snapshot.body[index].gameUrl}?game_token=$gameToken&base_url=$baseUrl&score_divide_by=${snapshot.body[index].scoreEqualsTo}",
                                            //  webviewcontroller: firstGameController,
                                          )),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Image.asset(
                                    "assets/popups/game_popups/speed-over-water/yes.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Image.asset(
                                    "assets/popups/game_popups/speed-over-water/No.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;
      case "Space Hero":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/popups/game_popups/space-hero/EnterPointDeductionPopup.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: MediaQuery.of(context).size.width * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => WebGameView(
                                            gameData: snapshot.body[index],
                                            callBack: () => {setState(() {})},
                                            coinBalanceController:
                                                coinBalanceController,
                                            gameUrl:
                                                "${snapshot.body[index].gameUrl}?game_token=$gameToken&base_url=$baseUrl&score_divide_by=${snapshot.body[index].scoreEqualsTo}",
                                          )),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Image.asset(
                                    "assets/popups/game_popups/space-hero/yes.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Image.asset(
                                    "assets/popups/game_popups/space-hero/No.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
    }
  }

  void _notEnoughPointzDialog(
      BuildContext context, int points, String gameName) {
    switch (gameName) {
      case "Cat 3 Match":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/popups/game_popups/cat_3_match/notEnough.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.28,
                          right: MediaQuery.of(context).size.width * 0.28,
                          //top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.2,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Image.asset(
                                "assets/popups/game_popups/cat_3_match/close.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;
      case "Speed Over Water":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/popups/game_popups/speed-over-water/Group 1 copy.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.25,
                          right: MediaQuery.of(context).size.width * 0.25,
                          //top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Image.asset(
                                "assets/popups/game_popups/speed-over-water/04.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;

      case "Super Sugar Hallucination":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/popups/game_popups/game1/notEnoughpointz.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.3,
                          right: MediaQuery.of(context).size.width * 0.3,
                          top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.18,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Image.asset(
                                "assets/popups/game_popups/game1/closebutton.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;
      case "Space Hero":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/popups/game_popups/space-hero/space copy.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.25,
                          right: MediaQuery.of(context).size.width * 0.25,
                          //top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Image.asset(
                                "assets/popups/game_popups/space-hero/02.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;
      default:
    }
  }

  void getPlaySectionData() async {
    PlaySectionData response = await Api().getNewPlaySectionData(context);
    if (response.done && response.body != null) {
      setState(() {
        _playSectionData = response;
      });
    }
  }

  void InterstitialAdResponse(
      {BuildContext context, PlaySectionData snapshot, int index}) async {
    if (snapshot.body[index].type == "quiz") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((context) => QuizGames())),
          (route) => false);
    } else {
      GameToken response = await Api()
          .getGameToken(snapshot.body[index].id, snapshot.body[index].type);
      if (response != null) {
        if (response.done) {
          setState(() {
            snapshot.body[index].loading = false;
            buttonLoading = false;
          });
          String token = response.body.token;
          snapshot.body[index].type == "Level"
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => WebGameView(
                          gameData: snapshot.body[index],
                          callBack: () => {setState(() {})},
                          coinBalanceController: coinBalanceController,
                          gameUrl:
                              "${snapshot.body[index].gameUrl}?game_token=$token&base_url=$baseUrl",
                        )),
                  ),
                )
              : snapshot.body[index].type == "Score"
                  ? pointDeductionPopup(context, response.body.points,
                      snapshot.body[index].name, snapshot, index, token)
                  : () {};
        } else {
          setState(() {
            buttonLoading = false;
            snapshot.body[index].loading = false;
          });
          _notEnoughPointzDialog(context, 0, snapshot.body[index].name);
        }
      }
    }
  }

  Widget gameQuizButton(
      BuildContext context, PlaySectionData snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () async {
            if (adFailedToLoad) {
              ShowLoadingPopUp(context);
              InterstitialAdResponse(
                  context: context, snapshot: snapshot, index: index);
            } else {
              _showInterstitialAd(
                  context: context, snapshot: snapshot, index: index);
            }
            setState(() {
              !snapshot.body[index].loading
                  ? snapshot.body[index].loading = true
                  : null;
            });
          },
          child: Opacity(
            opacity: adLoaded || adFailedToLoad ? 1.0 : 0.5,
            child: Image(
                image: AssetImage(snapshot.body[index].name ==
                        "Super Sugar Hallucination"
                    ? "assets/new_play_section/game_01_super_sugar.png"
                    : snapshot.body[index].name == "Space Hero"
                        ? "assets/new_play_section/space_hero.png"
                        : snapshot.body[index].type == "quiz"
                            ? "assets/new_play_section/quizGames.png"
                            : snapshot.body[index].name == "Speed Over Water"
                                ? "assets/new_play_section/speed_over_water.png"
                                : snapshot.body[index].name == "Cat 3 Match"
                                    ? "assets/new_play_section/cat3match.png"
                                    : ""),
                fit: BoxFit.fill),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
        backgroundColor:
            darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
        body: userController.currentUser.value != null
            ? !userController.currentUser.value.is_brand_acc
                ? _playSectionData != null
                    ? _playSectionData.done
                        ? Stack(
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        primary: false,
                                        shrinkWrap: false,
                                        itemCount: _playSectionData.body.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          // if (index == 1) {
                                          //   return Column(
                                          //     children: [
                                          //       InlineAdaptiveBannerAds(
                                          //         bannerWidth: 320,
                                          //         bannerHeight: 100,
                                          //       ),
                                          //       InkWell(
                                          //         onTap: () {
                                          //           navigator.push(
                                          //               MaterialPageRoute(
                                          //                   builder: (context) =>
                                          //                       MyGamePage()));
                                          //         },
                                          //         child: Padding(
                                          //           padding:
                                          //               EdgeInsets.symmetric(
                                          //                   horizontal: 10,
                                          //                   vertical: 15),
                                          //           child: Container(
                                          //             child: Center(
                                          //               child: Container(
                                          //                 decoration: BoxDecoration(
                                          //                     color:
                                          //                         Colors.yellow,
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 4)),
                                          //                 padding:
                                          //                     EdgeInsets.all(4),
                                          //                 child: Text(
                                          //                   "Digital දාම් අදිමු",
                                          //                   style: TextStyle(
                                          //                       color: Colors
                                          //                           .black,
                                          //                       fontSize: 30,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .bold),
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //             decoration: BoxDecoration(
                                          //                 image: DecorationImage(
                                          //                     image: AssetImage(
                                          //                         'assets/new_play_section/dam_board.png'),
                                          //                     fit: BoxFit.fill),
                                          //                 color: Colors.red,
                                          //                 borderRadius:
                                          //                     BorderRadius
                                          //                         .circular(
                                          //                             10)),
                                          //             height: 100,
                                          //             width: double.infinity,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       InlineAdaptiveBannerAds(
                                          //         bannerWidth: 320,
                                          //         bannerHeight: 100,
                                          //       ),
                                          //     ],
                                          //   );
                                          // }

                                          // if (index == 2) {
                                          //   return InkWell(
                                          //     onTap: () {
                                          //       navigator.push(
                                          //           MaterialPageRoute(
                                          //               builder: (context) =>
                                          //                   HomePage()));
                                          //     },
                                          //     child: Padding(
                                          //       padding:
                                          //           const EdgeInsets.symmetric(
                                          //               horizontal: 10,
                                          //               vertical: 10),
                                          //       child: Container(
                                          //         child: Center(
                                          //           child: Text(
                                          //             "Santa Clash",
                                          //             style: TextStyle(
                                          //                 color: Colors.white,
                                          //                 fontSize: 20,
                                          //                 fontWeight:
                                          //                     FontWeight.bold),
                                          //           ),
                                          //         ),
                                          //         decoration: BoxDecoration(
                                          //             color: Colors.red,
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     10)),
                                          //         height: 100,
                                          //         width: double.infinity,
                                          //       ),
                                          //     ),
                                          //   );
                                          // }
                                          if (_playSectionData
                                                  .body[index].type ==
                                              "Level") {
                                            return gameQuizButton(context,
                                                _playSectionData, index);
                                          } else if (_playSectionData
                                                  .body[index].type ==
                                              "Score") {
                                            return gameQuizButton(context,
                                                _playSectionData, index);
                                          } else if (_playSectionData
                                                  .body[index].type ==
                                              "normalAd") {
                                            return StoreBannerAD();
                                          } else if (_playSectionData
                                                  .body[index].type ==
                                              "googleAd") {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              child: InlineAdaptiveBannerAds(
                                                bannerWidth: 320,
                                                bannerHeight: 100,
                                              ),
                                            );
                                          } else if (_playSectionData
                                                  .body[index].type ==
                                              "quiz") {
                                            return gameQuizButton(context,
                                                _playSectionData, index);
                                          } else {
                                            return null;
                                          }
                                        }),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: buttonLoading,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 8),
                                  child: Container(
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Center(child: Text("No posts Available"))
                    : Center(
                        child: ListView.builder(
                          itemCount: 6,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ShimmerWidget(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width,
                              isCircle: false,
                            ),
                          ),
                        ),
                      )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            SizedBox(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 30, right: 20, bottom: 20, left: 20),
                                child: Text(
                                  'You don\'t have access for this section',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 253, 118, 3),
                                      fontSize: 16),
                                ),
                                width: MediaQuery.of(context).size.width - 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Color.fromARGB(255, 253, 118, 3),
                                        width: 1.2)),
                              ),
                            ),
                            Positioned(
                              child: SizedBox(
                                height: 40,
                                width: 20,
                                child: Image.asset(
                                  'assets/bg/infobg.png',
                                ),
                              ),
                              right: 0,
                              left: 0,
                              top: -20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
            : Center(
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerWidget(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      isCircle: false,
                    ),
                  ),
                ),
              ));
  }
}
