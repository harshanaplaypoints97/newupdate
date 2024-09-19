import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:play_pointz/Provider/darkModd.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/profile/profile.dart';
import 'package:play_pointz/screens/shimmers/shimmer_profile_view.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_share/social_share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../Shared Pref/player_pref.dart';
import '../../../../constants/style.dart';
import '../../../../models/markertPlace/MarkertPlace_Profile_Item.dart';
import '../../../../screens/Chat/Provider/Chat_provider.dart';
import '../../../../widgets/profile/profile_name.dart';

class MarkertPlaceItemView extends StatefulWidget {
  final List<MarketplaceMedia> imageList;
  final String PlayerImage;
  final String Playername;
  final String playerid;
  final String ItemName;
  final String ItemImage;
  final String ItemDescription;
  final String ItemPrice;

  final int index;

  const MarkertPlaceItemView(
      {Key key,
      @required this.PlayerImage,
      @required this.Playername,
      @required this.imageList,
      @required this.playerid,
      @required this.ItemName,
      @required this.ItemDescription,
      @required this.ItemImage,
      @required this.ItemPrice,
      @required this.index})
      : super(key: key);

  @override
  State<MarkertPlaceItemView> createState() => _MarkertPlaceItemViewState();
}

class _MarkertPlaceItemViewState extends State<MarkertPlaceItemView> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  int num = 0;
  Future<void> initialaddclick() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int numClicks = prefs.getInt('numClicks') ??
        0; // Get the current number of clicks or default to 0
    numClicks++;
    prefs.setInt('numClicks',
        numClicks); // Update the number of clicks in SharedPreferences

    if (numClicks == 0 || numClicks % 3 == 0) {
      // Check if it's the 5th click
      // Load and show the interstitial ad
      loadInterstitialAd(
        onAdLoaded: () async {
          await _interstitialAd?.show();
        },
      );
    }

    setState(() {
      num = numClicks;
    });

    print(num);
  }

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  bool adLoaded = true;
  bool adFailedToLoad = false;
  void loadInterstitialAd({VoidCallback onAdLoaded}) {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? admobAppIdInterstitialAndroid
          : admobAppIdInterstitialIOS,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              // Ad has been dismissed full screen content
              ad.dispose(); // Dispose the ad once it's dismissed
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              // Ad failed to show full screen content
              ad.dispose(); // Dispose the ad in case of failure
            },
          );
          // Invoke the callback when the ad is loaded
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          // Handle ad failed to load
          print('Interstitial Ad failed to load: $error');
        },
      ),
    );
  }

  bool isWhatsappProcessing = false;

  bool itisprocessing = false;
  bool loadingdata = false;
  String refarrallink = "";
  var data;
  getRefarralLink() async {
    setState(() {
      loadingdata = true;
    });
    data = await getPlayerPref(key: "playerProfileDetails");

    setState(() {
      refarrallink = "$baseUrl/invite/${data['invite_token']}";

      loadingdata = false;
    });
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  UserController userController = Get.put(UserController());
  TextEditingController chatcontroller = TextEditingController();
  Map<String, dynamic> paymentIntent;
  int ItemCount = 1;

  @override
  void initState() {
    setState(() {
      chatcontroller.text = "Hi, Is the " + widget.ItemName + " available?";
    });

    // TODO: implement initState
    super.initState();
    loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          color: darkModeProvider.isDarkMode ? AppColors.WHITE : Colors.black,
        ),
        backgroundColor:
            darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
      ),
      backgroundColor:
          darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          await initialaddclick(); // Call initialaddclick when popping the scope
          navigator.pop();
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            color:
                darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 40,
                // ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: Container(
                        color: darkModeProvider.isDarkMode
                            ? AppColors.darkmood
                            : Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 16 / 14,
                            viewportFraction: 1.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: widget.imageList.map((MarketplaceMedia media) {
                            return Builder(
                              builder: (BuildContext context) {
                                if (media.imageUrl != null) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                    child: CachedNetworkImage(
                                      cacheManager: CustomCacheManager.instance,
                                      errorWidget: (context, url, error) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      },
                                      imageUrl: media.imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return null; // Return null when imageUrl is null
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buidindicator(widget.imageList.length),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.ItemName,
                        style: TextStyle(
                            fontSize: 22,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w700,
                            color: darkModeProvider.isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black),
                      ),
                      Text(
                        "LKR " +
                            NumberFormat('###,000')
                                .format(int.parse(widget.ItemPrice)),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffDE481B)),
                      ),
                      userController.currentUser.value.id.toString() ==
                              widget.playerid.toString()
                          ? Container()
                          : Consumer<ChatProvider>(
                              builder: (context, value, child) => TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(
                                      8), // Remove default padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {
                                  // print(userController.currentUser.value.id.toString());

                                  // print(widget.playerid.toString());

                                  value.statrCreateConvercation(
                                    context,
                                    userController.currentUser.value.id,
                                    widget.playerid,
                                    0,
                                    widget.PlayerImage,
                                    widget.Playername,
                                    userController
                                        .currentUser.value.profileImage,
                                    userController.currentUser.value.fullName,
                                    chatcontroller.text,
                                  );
                                },
                                child: value.loadingindex == 1
                                    ? CircularPercentIndicator()
                                    : Container(
                                        //If You Need To Add Contact Number
                                        height:
                                            MediaQuery.of(context).size.width /
                                                2 *
                                                0.7,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Divider(
                                              color: darkModeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Send massage to seller",
                                                  style: TextStyle(
                                                      decorationThickness: 2.5,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: darkModeProvider
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xffFF7D3A))),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      9,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.4,
                                                  child: TextFormField(
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    maxLength: 30,
                                                    buildCounter: (BuildContext
                                                                context,
                                                            {int currentLength,
                                                            int maxLength,
                                                            bool isFocused}) =>
                                                        null,
                                                    decoration: InputDecoration(
                                                      fillColor:
                                                          Color(0xffFFEBE1),
                                                      filled: true,
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      labelStyle:
                                                          AppStyles.lableText,
                                                      hintText:
                                                          'Type Your Text',
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 0, 15, 0),
                                                    ),
                                                    controller: chatcontroller,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return ("Type your Message");
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Icon(
                                                    FontAwesomeIcons
                                                        .solidPaperPlane,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),

                                            ///////////////////////////   Seller Contact Number Details

                                            // Text(
                                            //   "Seller Contact Number",
                                            //   style: TextStyle(
                                            //       decorationThickness: 2.5,
                                            //       fontSize: 14,
                                            //       fontWeight: FontWeight.w600,
                                            //       color: darkModeProvider
                                            //               .isDarkMode
                                            //           ? Colors.white
                                            //           : Colors.black),
                                            // ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),

                                            // InkWell(
                                            //   onTap: () {
                                            //     _makePhoneCall('07145682646');
                                            //   },
                                            //   child: Container(
                                            //     height: 40,
                                            //     width: MediaQuery.of(context)
                                            //             .size
                                            //             .width /
                                            //         1.4,
                                            //     decoration: BoxDecoration(
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 10),
                                            //         color: Colors.green),
                                            //     child: Center(
                                            //       child: Row(
                                            //         mainAxisAlignment:
                                            //             MainAxisAlignment
                                            //                 .center,
                                            //         children: [
                                            //           Icon(
                                            //             Icons.call,
                                            //             size: 20,
                                            //             color: Colors.white,
                                            //           ),
                                            //           SizedBox(
                                            //             width: 2,
                                            //           ),
                                            //           Text(
                                            //             "07X XXX XXXX",
                                            //             style: TextStyle(
                                            //                 color:
                                            //                     Colors.white),
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.start,
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,
                                            //   children: [
                                            //     CircleAvatar(
                                            //       radius: MediaQuery.of(context)
                                            //               .size
                                            //               .width *
                                            //           0.06,
                                            //       backgroundColor: Colors.white,
                                            //       child: CircleAvatar(
                                            //         backgroundColor:
                                            //             Colors.transparent,
                                            //         radius:
                                            //             MediaQuery.of(context)
                                            //                     .size
                                            //                     .width *
                                            //                 0.083,
                                            //         backgroundImage:
                                            //             NetworkImage(
                                            //           widget.PlayerImage ??
                                            //               "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     Padding(
                                            //       padding:
                                            //           const EdgeInsets.all(8.0),
                                            //       child: Container(
                                            //         child: Column(
                                            //           children: [
                                            //             Text(
                                            //               widget.Playername
                                            //                           .length >
                                            //                       15
                                            //                   ? widget.Playername
                                            //                       .substring(
                                            //                           0, 15)
                                            //                   : widget
                                            //                       .Playername,
                                            //               style: TextStyle(
                                            //                 color: darkModeProvider
                                            //                         .isDarkMode
                                            //                     ? Colors.white
                                            //                         .withOpacity(
                                            //                             0.5)
                                            //                     : Colors.black,
                                            //                 fontSize: 14,
                                            //               ),
                                            //             )
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     )
                                            //   ],
                                            // ),
                                            Divider(
                                              color: darkModeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                      ////////////////////////////////////////////////////share bellow ////////////////////////////////////////////////////
                      ///
                      ///
                      // userController.currentUser.value.id.toString() ==
                      //         widget.playerid.toString()
                      //     ? Container(
                      //         height: 10,
                      //       )
                      //     : Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           GestureDetector(
                      //             onTap: () async {
                      //               getRefarralLink();
                      //               setState(() {
                      //                 itisprocessing = true;
                      //               });

                      //               // Introduce a delay (e.g., 2 seconds)
                      //               await Future.delayed(Duration(seconds: 2));

                      //               final downloadlink =
                      //                   'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';
                      //               await Share.share(widget.ItemName +
                      //                   '\n\n' +
                      //                   widget.ItemDescription +
                      //                   '\n\n' +
                      //                   widget.imageList[0].imageUrl +
                      //                   '\n\n' +
                      //                   'Download Link => $refarrallink');

                      //               setState(() {
                      //                 // Reset the flag to indicate that the process is completed
                      //                 itisprocessing = false;
                      //               });
                      //             },
                      //             child: Stack(
                      //               alignment: Alignment.center,
                      //               children: [
                      //                 // Your regular GestureDetector child goes here
                      //                 itisprocessing
                      //                     ? Center(
                      //                         child: Container(
                      //                             width: 16,
                      //                             height: 16,
                      //                             child:
                      //                                 CircularProgressIndicator(
                      //                               strokeWidth: 2,
                      //                             )),
                      //                       )
                      //                     : Icon(
                      //                         FontAwesomeIcons.share,
                      //                         color: AppColors.normalTextColor
                      //                             .withOpacity(0.8),
                      //                         size: 19,
                      //                       ),

                      //                 // Show circular progress indicator when isProcessing is true
                      //               ],
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 20,
                      //           ),

                      //           //Whatsapp
                      //           GestureDetector(
                      //             onTap: () async {
                      //               getRefarralLink();
                      //               setState(() {
                      //                 isWhatsappProcessing = true;
                      //               });
                      //               final downloadlink =
                      //                   'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';

                      //               await Future.delayed(Duration(seconds: 2));

                      //               await SocialShare.shareWhatsapp(
                      //                   widget.ItemDescription +
                      //                       '\n\n' +
                      //                       widget.imageList[0].imageUrl +
                      //                       '\n\n' +
                      //                       'Download Link => $refarrallink');

                      //               setState(() {
                      //                 isWhatsappProcessing = false;
                      //               });
                      //             },
                      //             child: isWhatsappProcessing
                      //                 ? Center(
                      //                     child: Container(
                      //                         width: 16,
                      //                         height: 16,
                      //                         child: CircularProgressIndicator(
                      //                           strokeWidth: 2,
                      //                         )),
                      //                   )
                      //                 : Icon(
                      //                     FontAwesomeIcons.whatsapp,
                      //                     color: AppColors.normalTextColor
                      //                         .withOpacity(0.8),
                      //                     size: 20,
                      //                   ),
                      //           )
                      //         ],
                      //       ),

                      ////////////////////////////////////////////////////////////////////////////////////////////////////share upeer
                      Text(
                        "Details",
                        style: TextStyle(
                          color: darkModeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.ItemDescription,
                        style: TextStyle(
                          color: darkModeProvider.isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // userController.currentUser.value.id.toString() ==
                      //         widget.playerid.toString()
                      //     ? Container()
                      //     : Divider(),
                      // userController.currentUser.value.id.toString() ==
                      //         widget.playerid.toString()
                      //     ? Container()
                      //     : Text(
                      //         "Seller information",
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 18.sp,
                      //         ),
                      //       ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // userController.currentUser.value.id.toString() ==
                      //         widget.playerid.toString()
                      //     ? Container()
                      //     : Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 15),
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             // DefaultRouter.defaultRouter(ProfileNew(), context);
                      //             DefaultRouter.defaultRouter(
                      //               Profile(
                      //                 id: widget.playerid,
                      //                 myProfile: false,
                      //               ),
                      //               context,
                      //             );
                      //           },
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(10),
                      //               color: Colors.white,
                      //               border: Border.all(
                      //                 color: Color.fromARGB(
                      //                     255, 217, 217, 217), // Border color
                      //                 width: 1.0, // Border width
                      //               ),
                      //             ),
                      //             height: 90,
                      //             width: double.infinity,
                      //             child: Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   horizontal: 15),
                      //               child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.start,
                      //                 children: [
                      //                   //Profile Image
                      //                   // ProfileImage(profileData: profileData),
                      //                   ClipOval(
                      //                     child: CachedNetworkImage(
                      //                       cacheManager:
                      //                           CustomCacheManager.instance,
                      //                       imageUrl: widget.PlayerImage,
                      //                       width: 50.w,
                      //                       height: 50.w,
                      //                       fit: BoxFit.fill,
                      //                       fadeInDuration:
                      //                           const Duration(milliseconds: 600),
                      //                       fadeOutDuration:
                      //                           const Duration(milliseconds: 600),
                      //                       errorWidget: (a, b, c) {
                      //                         return CachedNetworkImage(
                      //                           cacheManager:
                      //                               CustomCacheManager.instance,
                      //                           imageUrl: widget.PlayerImage,
                      //                         );
                      //                       },
                      //                     ),
                      //                   ),

                      //                   SizedBox(
                      //                     width: 20,
                      //                   ),

                      //                   Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.center,
                      //                     children: [
                      //                       profileName(
                      //                         name: widget.Playername.length > 10
                      //                             ? widget.Playername.substring(
                      //                                 0, 10)
                      //                             : widget.Playername,
                      //                       )
                      //                     ],
                      //                   ),
                      //                   Spacer(),
                      //                   Center(
                      //                     child: Container(
                      //                       decoration: BoxDecoration(
                      //                         borderRadius:
                      //                             BorderRadius.circular(10),
                      //                         color: Colors.white,
                      //                         border: Border.all(
                      //                           color:
                      //                               Colors.grey, // Border color
                      //                           width: 1.0, // Border width
                      //                         ),
                      //                       ),
                      //                       child: Padding(
                      //                         padding: const EdgeInsets.all(8.0),
                      //                         child: Text(
                      //                           "view",
                      //                           style: TextStyle(
                      //                             color: Colors.black,
                      //                             fontWeight: FontWeight.w600,
                      //                             fontSize: 18.sp,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buidindicator(int len) => Center(
        child: AnimatedSmoothIndicator(
          activeIndex: _current,
          count: len,
          effect: WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: AppColors.PRIMARY_COLOR,
              dotColor: Color(0xff626262).withOpacity(0.9)),
        ),
      );
}
