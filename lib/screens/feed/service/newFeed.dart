// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/controllers/notification_controller.dart';
import 'package:play_pointz/controllers/profile_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/get_player_profile.dart';
import 'package:play_pointz/models/home/popup_banner.dart';
import 'package:play_pointz/models/play/game_token.dart';
import 'package:play_pointz/models/update_acc_images.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/feed/components/anouncement.dart';
import 'package:play_pointz/screens/feed/components/postcard/post_card.dart';
import 'package:play_pointz/screens/friends/friends_screen.dart';
import 'package:play_pointz/screens/google_ads/banner_ad.dart';
import 'package:play_pointz/screens/home/notifications.dart';
import 'package:play_pointz/screens/play/game_screen/feed_game_view.dart';
import 'package:play_pointz/screens/play/game_screen/web_game_view.dart';
import 'package:play_pointz/screens/play/quiz_games.dart';
import 'package:play_pointz/screens/player_profile/follow_status_button.dart';
import 'package:play_pointz/screens/player_profile/friend_status_button.dart';
import 'package:play_pointz/screens/profile/Edit%20Profile%20Sections/Main_edit_profile.dart';
import 'package:play_pointz/screens/profile/edit_profile.dart';
import 'package:play_pointz/screens/orders/my_orders.dart';
import 'package:play_pointz/screens/profile/profile_settings.dart';
import 'package:play_pointz/screens/shimmers/shimmer_post_list.dart';
import 'package:play_pointz/screens/shimmers/shimmer_profile_view.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';
import 'package:play_pointz/services/image_cropper/image_cropper.dart';
import 'package:play_pointz/store/widgets/Rest%20WinnerNewFeedCard.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/play/find_missing_character_card.dart';
import 'package:play_pointz/widgets/profile/profile_name.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Provider/darkModd.dart';
import '../../../controllers/quiz_controller.dart';
import '../../../models/play/play_section_data.dart';
import '../../../store/recent_winner_container.dart';
import '../../../store/widgets/RestWinnerNewFeedConatiner.dart';
import '../../../widgets/play/quiz_card.dart';
import '../../../widgets/play/word_correction.dart';
import '../../Chat/Provider/Chat_provider.dart';

import '../../friends/friends_search_results_screen.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../google_ads/inline_adaptive_banner_ads.dart';

class newFeed extends StatefulWidget {
  final String id;
  final bool myProfile;
  final String postId;
  const newFeed({Key key, this.id, this.myProfile, this.postId})
      : super(key: key);
  @override
  State<newFeed> createState() => _newFeedState();
}

class _newFeedState extends State<newFeed> {
  final NotificationController notificationController =
      Get.put(NotificationController());

  // var profileData;
  String base64Image;
  PickedFile profilImage;
  PickedFile coverImage;
  Uint8List bytes;
  Io.File image;
  bool loadingdata = false;
  bool isLoading;
  bool seeMore = false;
  int allpostcount = 0;
  // List<PostModel> data = [];
  var temp = [];
  BodyOfProfileData player = BodyOfProfileData();
  bool playerDataLoading = false;
  bool isFinished = false;
  int limit = 10;
  int postoffset = 0;
  final postScrollController = ScrollController();
  final feedcontroller = Get.put(FeedController());
  String unReadNotificationCount = '';

  UserController userController = Get.put(UserController());
  final profileController = Get.put(ProfileController());
  // ProfileController profileController;

  @override
  void initState() {
    profileController.GetProfileFeed(
        offset: profileController.profileFeed.length ?? 0, userId: widget.id);
    setProfileData();
    //  profileController = Get.put(ProfileController(widget.id));
    //getpost();
    postScrollController.addListener(postScrollListner);
    if (userController.currentUser.value == null) {
      userController.setCurrentUser().then((value) => setState(() {}));
    }

    _createInterstitialAd();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    getPlaySectionData();

    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    setState(() {
      quizController = Get.put(QuizController(
        callback: () {
          setState(() {});
        },
      ));
    });

    getNotificationCount();
    super.initState();
    showLatePopup();
    super.initState();
  }

  void returnCallBack() {
    setState(() {
      coinBalanceController.onInit();
    });

    super.initState();
  }

  void getNotificationCount() {
    final li = notificationController.notifications
        .where((element) => !element.is_read)
        .toList();
    unReadNotificationCount = li.length.toString();
  }

  void loadQuiz() async {
    setState(() {
      isLoading = true;
    });
    await quizController.setList().then((value) => setState(() {}));
    setState(() {
      isLoading = false;
    });
  }

  showLatePopup() async {
    PopUpData data = await Api().getlatePopUp();
    if (data.done) {
      if (data.body != null) {
        loadPopup(data.body.image_url, data.body.id);
      }
    }
  }

  loadPopup(String imgUrl, String id) {
    try {
      var _image = NetworkImage(imgUrl);

      _image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (info, call) {
            showPopupBanner(imgUrl, id, context);
          },
        ),
      );
    } catch (e) {}
  }

  void showPopupBanner(String imgUrl, String id, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.only(bottom: 0),
        content: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 36),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/bg/loading2.gif",
                    image: imgUrl,
                  ),
                ),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 153, 55),
                        shape: BoxShape.circle,
                        // border: Border.all(color: Colors.white, width: 2)
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'X',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
    Api api = Api();
    api.popupSeen(id);
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    profileController.dispose();

    super.dispose();
  }

  getShortForm(int number) {
    var shortForm = "";
    if (number != null) {
      if (number < 1000) {
        shortForm = number.toString();
      } else if (number >= 1000 && number < 1000000) {
        shortForm = (number / 1000).toStringAsFixed(1) + "K";
      } else if (number >= 1000000 && number < 1000000000) {
        shortForm = (number / 1000000).toStringAsFixed(1) + "M";
      } else if (number >= 1000000000 && number < 1000000000000) {
        shortForm = (number / 1000000000).toStringAsFixed(1) + "B";
      }
    }
    return shortForm;
  }

  void postScrollListner() {
    if (!profileController.dataloading.value) {
      if (postScrollController.offset >
          postScrollController.position.maxScrollExtent - 10) {
        if (profileController.allPostsCount >
            profileController.profileFeed.length) {
          profileController.GetProfileFeed(
              offset: profileController.profileFeed.length ?? 0,
              userId: widget.id);
        }
      }
    }
  }

  void stateChanger() {
    setState(() {});
  }

  Future<void> setProfileData() async {
    try {
      if (widget.id != null) {
        setState(() {
          playerDataLoading = true;
        });
        GetPlayerProfile getProfile =
            await Api().getPlayersProfle(playerId: widget.id);
        setState(() {
          player = getProfile.body;

          playerDataLoading = false;
        });
      }
    } catch (e) {}
  }

  bool shouldLoad = false;

  Future<void> _showChoiceDialog(
    BuildContext context,
    String type,
    bool isProfilePicure,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ValueListenableBuilder(
              valueListenable: uploading,
              builder: (context, bool value, _) {
                return AlertDialog(
                  title: value
                      ? Text("Uploading")
                      : const Text(
                          "Choose option",
                          style: TextStyle(color: Colors.blue),
                        ),
                  content: value
                      ? SizedBox(
                          height: kToolbarHeight * 1.8,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.PRIMARY_COLOR,
                          )),
                        )
                      : SingleChildScrollView(
                          child: ListBody(
                            children: [
                              const Divider(
                                height: 1,
                                color: Colors.blue,
                              ),
                              ListTile(
                                onTap: () {
                                  _openGallery(context, type, isProfilePicure);
                                },
                                title: const Text("Gallery"),
                                leading: const Icon(
                                  Icons.account_box,
                                  color: Colors.blue,
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: Colors.blue,
                              ),
                              ListTile(
                                onTap: () {
                                  _openCamera(context, type, isProfilePicure);
                                },
                                title: Text("Camera"),
                                leading: const Icon(
                                  Icons.camera,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              });
        });
  }

  //////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////////////
  bool buttonLoading = false;
  bool adLoaded = false;
  bool adFailedToLoad = false;
  CoinBalanceController coinBalanceController;

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
    // ShowLoadingPopUp(context);
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
                              // Navigator.pop(context);
                              // Navigator.pop(context);
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
                    builder: ((context) => FeedGameView(
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
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
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

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: darkModeProvider.isDarkMode
                        ? AppColors.darkmood
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                height: 300,
                width: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    snapshot.body[index].name == "Super Sugar Hallucination"
                        ? "assets/new_play_section/game_01_super_sugar.webp"
                        : snapshot.body[index].name == "Space Hero"
                            ? "assets/new_play_section/space hero.webp"
                            : snapshot.body[index].type == "quiz"
                                ? "assets/new_play_section/quizGames.png"
                                : snapshot.body[index].name ==
                                        "Speed Over Water"
                                    ? "assets/new_play_section/speed_over_water.webp"
                                    : snapshot.body[index].name == "Cat 3 Match"
                                        ? "assets/new_play_section/cat3match.webp"
                                        : "",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            // child: Image(
            // image: AssetImage(snapshot.body[index].name ==
            //         "Super Sugar Hallucination"
            //     ? "assets/new_play_section/game_01_super_sugar.png"
            //     : snapshot.body[index].name == "Space Hero"
            //         ? "assets/new_play_section/space_hero.png"
            //         : snapshot.body[index].type == "quiz"
            //             ? "assets/new_play_section/quizGames.png"
            //             : snapshot.body[index].name == "Speed Over Water"
            //                 ? "assets/new_play_section/speed_over_water.png"
            //                 : snapshot.body[index].name == "Cat 3 Match"
            //                     ? "assets/new_play_section/cat3match.png"
            //                     : ""),
            //     fit: BoxFit.fill),
          )),
    );
  }

  //Quiz

  var controller = ConfettiController();
  QuizController quizController;
  bool coinThrow = false;

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);

    final size = MediaQuery.of(context).size;
    // final profileController = Get.put(ProfileController(widget.id));
    return Scaffold(
      backgroundColor:
          darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              setProfileData();
            });
          },
          child: SingleChildScrollView(
            controller: postScrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                SizedBox(
                  height: size.width * 0.01,
                ),
                profileController.profileFeed != null
                    ? profileController.profileFeed.isEmpty
                        ? ShimmerPostList()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: profileController.profileFeed.length,
                            itemBuilder: (context, index) {
                              List<int> gameIndices = [1, 2, 3, 4, 5, 6];

                              bool isgamepostion =
                                  (index + 1) % 7 == 0 && index != 0;
                              bool isAdPosition =
                                  (index + 1) % 3 == 0 && index != 0;
                              bool iswinnerPost =
                                  (index + 1) % 5 == 0 && index != 0;
                              bool annoucement =
                                  (index + 1) % 4 == 0 && index != 0;

                              int actualIndex = index - (index ~/ 4);

                              if (isAdPosition) {
                                // Insert AdMob widget here
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: InlineAdaptiveBannerAds(
                                    bannerWidth: 320,
                                    bannerHeight: 250,
                                  ),
                                );
                              } else if (isgamepostion &&
                                  userController
                                          .currentUser.value.is_brand_acc ==
                                      false) {
                                int gameIndex =
                                    gameIndices[index % gameIndices.length];
                                if (_playSectionData.body[gameIndex].type ==
                                    "Level") {
                                  return gameQuizButton(
                                      context, _playSectionData, gameIndex);
                                } else if (_playSectionData
                                        .body[gameIndex].type ==
                                    "Score") {
                                  return gameQuizButton(
                                      context, _playSectionData, gameIndex);
                                } else if (_playSectionData
                                        .body[gameIndex].type ==
                                    "quiz") {
                                  return gameQuizButton(
                                      context, _playSectionData, gameIndex);
                                } else {
                                  return Container();
                                }
                              } else if (iswinnerPost) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      RestWinnerFeedContainer(),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                );
                              } else if (annoucement &&
                                  userController
                                          .currentUser.value.is_brand_acc ==
                                      false) {
                                for (int quizIndex = 0;
                                    quizIndex < quizController.quiz.length;
                                    quizIndex++) {
                                  print("lengtg" +
                                      quizController.quiz[quizIndex].points
                                          .toString());

                                  if (quizController.quiz[quizIndex].type ==
                                      "quiz") {
                                    return QuizCard(
                                      confettiController: controller,
                                      controller: coinBalanceController,
                                      quiz: quizController.quiz[quizIndex],
                                      callback: () => {setState(() {})},
                                      animationPlayCallback: () => setState(() {
                                        coinThrow = true;
                                        controller.play();
                                      }),
                                      animationStopCallback: () => setState(() {
                                        coinThrow = false;
                                        controller.stop();
                                      }),
                                    );
                                  } else if (quizController
                                          .quiz[quizIndex].type ==
                                      "wc_game") {
                                    return WordCorrectionCard(
                                      userController: userController,
                                      confettiController: controller,
                                      controller: coinBalanceController,
                                      callback: () => {setState(() {})},
                                      animationPlayCallback: () => setState(() {
                                        coinThrow = true;
                                        controller.play();
                                      }),
                                      animationStopCallback: () => setState(() {
                                        coinThrow = false;
                                        controller.stop();
                                      }),
                                      wcGame: quizController.quiz[quizIndex],
                                    );
                                  } else if (quizController
                                          .quiz[quizIndex].type ==
                                      "mc_game") {
                                    return FindMissingCharacterCard(
                                      userController: userController,
                                      confettiController: controller,
                                      controller: coinBalanceController,
                                      callback: () => {setState(() {})},
                                      animationPlayCallback: () => setState(() {
                                        coinThrow = true;
                                        controller.play();
                                      }),
                                      animationStopCallback: () => setState(() {
                                        coinThrow = false;
                                        controller.stop();
                                      }),
                                      mcGame: quizController.quiz[quizIndex],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                              } else {
                                // Normal item rendering
                                if (profileController.profileFeed[actualIndex]
                                        ["type"] ==
                                    'post') {
                                  return PostCard(
                                    fromNotification: false,
                                    postModel: profileController
                                        .profileFeed[actualIndex]["model"],
                                    index: actualIndex,
                                    callbackAction: () {
                                      setState(() {});
                                    },
                                    isFromFeed: false,
                                    profileController: profileController,
                                    updatePost: () {
                                      profileController.GetProfileFeed(
                                          offset: 0, userId: widget.id);
                                    },
                                  );
                                } else if (profileController
                                        .profileFeed[actualIndex]["type"] ==
                                    'announcement') {
                                  return Anouncement(
                                    animating: false,
                                    animatingCongrats: false,
                                    index: index,
                                    isFromFeed: false,
                                    //profileController: profileController,
                                    anounce: profileController
                                        .profileFeed[actualIndex]["model"],
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            })
                    : LinearProgressIndicator()
              ],
            ),
          ),
        );
      }),
    );
  }

  ValueNotifier<bool> uploading = ValueNotifier(false);
  void _openGallery(
      BuildContext context, String type, bool isProfilePicure) async {
    final pickedFile = await ImageCropperService.pickMedia(
      cropImage: ImageCropperService.cropSquareImage,
      isGallery: true,
      isProfilePicure: isProfilePicure,
    );
    bytes = await Io.File(pickedFile.path).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    base64Image = base64Encode(bytes);

    if (type == 'profile') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result =
          await Api().setProfileImages(type, base64Image.toString());

      if (result.done != null && result.done) {
        setState(() {
          profilImage = PickedFile(pickedFile.path);
          /*  profileData['profile_image'] */ userController
              .currentUser.value.profileImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else if (type == 'cover') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result =
          await Api().setCoverImages(type, base64Image.toString());
      if (result.done != null && result.done) {
        setState(() {
          coverImage = PickedFile(pickedFile.path);
          userController.currentUser.value.coverImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else {
      coverImage = coverImage;
    }
    setState(() {
      uploading.value = false;
    });
    Navigator.pop(context);
    //Navigator.pop(context);
  }

  void _openCamera(
      BuildContext context, String type, bool isProfilePicure) async {
    final pickedFile = await ImageCropperService.pickMedia(
      cropImage: ImageCropperService.cropSquareImage,
      isGallery: false,
      isProfilePicure: isProfilePicure,
    );
    bytes = await Io.File(pickedFile.path).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    base64Image = base64Encode(bytes);
    if (type == 'profile') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result = await Api().setProfileImages(type, base64Image);

      if (result.done != null && result.done) {
        setState(() {
          profilImage = PickedFile(pickedFile.path);
          userController.currentUser.value.profileImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else if (type == 'cover') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result = await Api().setCoverImages(type, base64Image);
      if (result.done != null && result.done) {
        setState(() {
          coverImage = PickedFile(pickedFile.path);
          userController.currentUser.value.coverImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else {
      coverImage = coverImage;
    }
    setState(() {
      uploading.value = false;
    });
    Navigator.pop(context);
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          // filled: true,
          // fillColor: Color(0xffC4C4C4),
          hintStyle: TextStyle(
              color: Color(
                0xff474747,
              ),
              fontSize: 18),
          labelStyle: TextStyle(color: Colors.red),
        ),
        primaryColor: Colors.grey[50],
        appBarTheme: theme.appBarTheme.copyWith(
          elevation: 0, // Set your desired elevation here
          color: AppColors.scaffoldBackGroundColor,
          // Set your desired color here
        ),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Color(
                  0xff474747,
                ),
                fontSize: 18)));
  }

  final userController = Get.put(UserController());
  List get names => userController.search.map((post) {
        return post;
      }).toList();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query == "" ? close(context, null) : query = "";
        },
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
        }
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Set elevation to 0.0 to remove shadow
    return FriendsSearchResults(
      query: query.toLowerCase(),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    // Customizing the search text field style with a border, input text color, and size
    return TextField(
      style: TextStyle(
          color: Colors.blue,
          fontSize: 16.0), // Set your desired text color and size
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red, // Set your desired border color
            width: 2.0, // Set your desired border width
          ),
        ),
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.red),
        filled: true,
        fillColor: Color(0xffC4C4C4),
      ),
      onChanged: (value) {
        query = value;
        // Implement any additional logic based on search query changes
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List n = names
        .where((name) =>
            name.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    // Set elevation to 0.0 to remove shadow
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10.0), // Set your desired border radius here
        color: Colors.grey[200], // Set your desired background color here
      ),
      child: ListView(
        children: n.map((e) {
          if (e != "") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  if (n.indexOf(e) ==
                      0) // Display "Recent" only for the first item
                    Text(
                      "Recent",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xff808080)),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      query = e;
                      showResults(context);
                    },
                    child: Container(
                      color: Color(0xffF5F5F5),
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              color: Color(0xffABABAB),
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              e,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Color(0xffABABAB)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox(
              width: 0,
              height: 0,
            );
          }
        }).toList(),
      ),
    );
  }
}
