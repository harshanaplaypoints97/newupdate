import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/home/popup_banner.dart';
import 'package:play_pointz/models/log_out.dart';
import 'package:play_pointz/screens/about_us/about_us_screen.dart';
import 'package:play_pointz/screens/connect/connect.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/home/splash_screen.dart';
import 'package:play_pointz/screens/profile/brand_page.dart';
import 'package:play_pointz/screens/profile/login_and_security.dart';
import 'package:play_pointz/screens/profile/profile.dart';

import 'package:play_pointz/screens/profile/support.dart';

import 'package:play_pointz/screens/register/Privacy_policy/privacy_policy.dart';
import 'package:play_pointz/screens/register/delivery_terms.dart';
import 'package:play_pointz/screens/register/terms_conditions.dart';
import 'package:play_pointz/widgets/common/app_bar.dart';
import 'package:play_pointz/widgets/common/notification_button.dart';
import 'package:play_pointz/widgets/common/popup.dart';
import 'package:play_pointz/widgets/common/toast.dart';
// import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/profile/dialog_Widget.dart';
import 'package:play_pointz/widgets/profile/profile_name.dart';
import 'package:play_pointz/widgets/profile/sub_screen_buttons.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:play_pointz/services/firebase_service.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../Provider/darkModd.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.unreadNotifications}) : super(key: key);
  String unreadNotifications;

  @override
  State<Settings> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<Settings> {
  bool _isSwitchOn = false; // Initial state of the switch

  Future<void> _toggleSwitch(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final darkModeProvider =
        Provider.of<DarkModeProvider>(context, listen: false);
    setState(() {
      _isSwitchOn = value;

      Logger().i(darkModeProvider.isDarkMode.toString());
    });

    if (value) {
      darkModeProvider.DarkmoodEnabaled();
      await prefs.setBool('darkmood', value);
    } else {
      darkModeProvider.DarkMoodDisable();
      await prefs.setBool('darkmood', value);
    }
  }

  bool myData = false;
  var profileData;
  getPlayerDetailsa() async {
    await HandleApi().getPlayerProfileDetails();
    profileData = await getPlayerPref(key: "playerProfileDetails");

    // setState(() {
    //   myData = true;
    // });
  }

  bool btnLoading = false;
  CoinBalanceController coinBalanceController;
  final UserController userController = Get.put(UserController());

  String devId = "";
  String current = '';

  final TextEditingController passwordController = TextEditingController();
  bool shouldVisible = false;

  showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(height: 150, color: Colors.red);
        });
  }

  getDeviceId() async {
    String deviceId = await PlatformDeviceId.getDeviceId;
    setState(() {
      devId = deviceId;
    });
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  getcurrent() async {
    const oneSec = Duration(seconds: 3);
    Timer.periodic(
        oneSec,
        (Timer t) => setState(() {
              current = '';
            }));
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
            print('Networkimage is fully loaded and saved');
            showPopupBanner(imgUrl, id, context);
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  deactivatedUser() async {
    try {
      setState(() {
        btnLoading = true;
      });
      Navigator.pop(context);
      alertDialogDeactivate(
          loading: btnLoading,
          passwordField: inputField(passwordController, "Password",
              isPassword: shouldVisible),
          context: context,
          function: () async {
            deactivatedUser();
          },
          cancel: () {
            setState(() {
              passwordController.clear();
            });
          });
      LogOut result = await Api().playerDeactivate(
          email: userController.currentUser.value.email,
          userName: userController.currentUser.value.username,
          password: passwordController.text);
      if (result.done) {
        LogOut result2 = await Api().PlayerLogOut();
        if (result2.done) {
          await SendUser().deleteDeviceToken();
          removePlayerPref(key: "playerProfileDetails");
          removePlayerPref(key: "search");
          Get.deleteAll();
          socket.destroy();

          setState(() {
            btnLoading = false;
          });
          final prefManager = await SharedPreferences.getInstance();
          await prefManager.clear();
          Restart.restartApp();
          socket.dispose();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainSplashScreen(),
            ),
            (route) => false,
          );
        }
      } else {
        setState(() {
          btnLoading = false;
        });
        messageToastRed(result.message);
        Navigator.pop(context);
        alertDialogDeactivate(
            loading: btnLoading,
            passwordField: inputField(passwordController, "Password",
                isPassword: shouldVisible),
            context: context,
            function: () async {
              deactivatedUser();
            },
            cancel: () {
              setState(() {
                passwordController.clear();
              });
            });
      }
    } catch (e) {
      debugPrint("++++++++++++++ deactivating failed" + e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPlayerDetailsa();
    getcurrent();
    getDeviceId();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    showLatePopup();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
        appBar: MainAppBar(
            coinBalanceController: coinBalanceController,
            context: context,
            unreadNotifications: widget.unreadNotifications,
            userController: userController),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              //Harshana Devolopment  upper part R*

              SizedBox(
                height: 10,
              ),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Stack(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                            image: AssetImage("assets/bg/card.png"),
                            fit: BoxFit
                                .cover, // You can use BoxFit.fill if you want the image to stretch
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        userController.currentUser.value
                                                    .fullName.length >
                                                20
                                            ? userController
                                                    .currentUser.value.fullName
                                                    .substring(0, 20) +
                                                "..."
                                            : userController.currentUser.value
                                                    .fullName ??
                                                "",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "@${userController.currentUser.value.username}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 90,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/logos/whitelogo.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "PTZ .",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          userController
                                              .currentUser.value.points
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '    ID Number',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userController.currentUser.value.id
                                            .substring(9, 23),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 0,
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Image(
                            image: AssetImage("assets/logos/coin.gif"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    ],
                  )),

              SizedBox(height: 20),
              //  Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //       context: context,
              //       displayText: "Delivery Information",
              //       displayIcon: FaIcon(FontAwesomeIcons.microphone),
              //       navigateScreen: () {
              //         DefaultRouter.defaultRouter(SupportPage(), context);
              //       }),
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: subScreenButton(
                    context: context,
                    displayText: "Contact Support",
                    displayIcon: FaIcon(
                      FontAwesomeIcons.microphone,
                      color: darkModeProvider.isDarkMode
                          ? Colors.white
                          : Colors.grey,
                    ),
                    navigateScreen: () {
                      DefaultRouter.defaultRouter(SupportPage(), context);
                    }),
              ),

              darkModeProvider.isDarkMode
                  ? Container(
                      height: 10,
                    )
                  : Container(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: subScreenButton(
                  context: context,
                  displayText: "About Us",
                  displayIcon: FaIcon(
                    Icons.report,
                    color: darkModeProvider.isDarkMode
                        ? Colors.white
                        : Colors.grey,
                  ),
                  navigateScreen: () => {
                    DefaultRouter.defaultRouter(AboutUsScreen(), context),
                  },
                ),
              ),
              darkModeProvider.isDarkMode
                  ? Container(
                      height: 10,
                    )
                  : Container(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: subScreenButton(
                  context: context,
                  displayText: "Terms & Conditions",
                  displayIcon: FaIcon(
                    Icons.fact_check,
                    color: darkModeProvider.isDarkMode
                        ? Colors.white
                        : Colors.grey,
                  ),
                  navigateScreen: () => {
                    DefaultRouter.defaultRouter(TermsConditions(), context),
                  },
                ),
              ),
              darkModeProvider.isDarkMode
                  ? Container(
                      height: 10,
                    )
                  : Container(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: subScreenButton(
                  context: context,
                  displayText: "Delivery Terms & Conditions",
                  displayIcon: FaIcon(
                    Icons.delivery_dining,
                    color: darkModeProvider.isDarkMode
                        ? Colors.white
                        : Colors.grey,
                  ),
                  navigateScreen: () => {
                    DefaultRouter.defaultRouter(
                        DeliveryTermsConditions(), context),
                  },
                ),
              ),
              darkModeProvider.isDarkMode
                  ? Container(
                      height: 10,
                    )
                  : Container(),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //     context: context,
              //     displayText: "Convert to Brand Page",
              //     displayIcon: FaIcon(Icons.swipe),
              //     navigateScreen: () => {
              //       DefaultRouter.defaultRouter(ConvertToPage(
              //         callback: () {
              //           setState(() {});
              //         },
              //       ), context)
              //     },
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: subScreenButton(
                  context: context,
                  displayText: "Delete your Account",
                  displayIcon: FaIcon(
                    Icons.delete,
                    color: darkModeProvider.isDarkMode
                        ? Colors.white
                        : Colors.grey,
                  ),
                  navigateScreen: () => {
                    alertDialogDeactivate(
                        loading: btnLoading,
                        passwordField: inputField(
                            passwordController, "Password",
                            isPassword: shouldVisible),
                        context: context,
                        function: () async {
                          deactivatedUser();
                        },
                        cancel: () {
                          setState(() {
                            passwordController.clear();
                          });
                        })
                  },
                ),
              ),
              darkModeProvider.isDarkMode
                  ? Container(
                      height: 10,
                    )
                  : Container(),

              // SizedBox(
              //   height: 5,
              // ), // Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: subScreenButton(
                    context: context,
                    displayText: "Log out",
                    displayIcon: FaIcon(
                      FontAwesomeIcons.signOutAlt,
                      color: darkModeProvider.isDarkMode
                          ? Colors.white
                          : Colors.grey,
                    ),
                    navigateScreen: () => alertDialog(
                          loading: btnLoading,
                          context: context,
                          function: () async {
                            setState(() {
                              btnLoading = true;
                            });

                            LogOut result = await Api().PlayerLogOut();
                            if (result.done) {
                              await SendUser().deleteDeviceToken();
                              removePlayerPref(key: "playerProfileDetails");
                              Get.deleteAll();

                              setState(() {
                                btnLoading = false;
                              });
                              final prefManager =
                                  await SharedPreferences.getInstance();
                              await prefManager.clear();
                              Restart.restartApp();
                              socket.dispose();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MainSplashScreen(),
                                ),
                                (route) => false,
                              );
                            } else {
                              setState(() {});
                            }
                          },
                        )),
              ),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 234, 87, 29),
                        Color.fromARGB(255, 209, 98, 54),
                        Color.fromARGB(255, 206, 131, 102),
                      ], // Start and end colors
                      begin:
                          Alignment.centerLeft, // Gradient starts from the left
                      end: Alignment.centerRight, // Gradient ends at the right
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Dark Mood",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Text(
                                "a sleek eye-friendly theme that saves battery\nand looks great",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                ),
                                maxLines: 2, // Set the maximum number of lines
                                overflow: TextOverflow
                                    .clip, // Add ellipsis when text overflows
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                        child: Switch(
                          value: darkModeProvider.isDarkMode,
                          onChanged: _toggleSwitch,
                          activeColor:
                              Colors.yellow, // Color when the switch is on
                          inactiveThumbColor: AppColors
                              .PRIMARY_COLOR_DARK, // Color when the switch is off
                        ),
                      )
                    ],
                  ),
                ),
              ) // Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputField(TextEditingController controller, String hintTetx,
      {bool isPassword = false}) {
    return TextFormField(
      obscureText: hintTetx == "Password" ? !isPassword : false,
      controller: controller,
      validator: (val) {
        if (val != null) {
          if (val.isEmpty) {
            return "Please fill this field";
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      maxLength: 20,
      decoration: InputDecoration(
        labelText: hintTetx,
        fillColor: AppColors.scaffoldBackGroundColor,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none),
        suffixIcon: hintTetx == "Password"
            ? IconButton(
                onPressed: () {
                  setState(() {
                    shouldVisible = !shouldVisible;
                  });
                  Navigator.pop(context);
                  alertDialogDeactivate(
                      loading: btnLoading,
                      passwordField: inputField(passwordController, "Password",
                          isPassword: shouldVisible),
                      context: context,
                      function: () async {
                        deactivatedUser();
                      },
                      cancel: () {
                        setState(() {
                          passwordController.clear();
                        });
                      });
                },
                icon: Icon(!shouldVisible
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye),
              )
            : null,
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  ProfileImage({
    Key key,
    @required this.profileData,
  }) : super(key: key);

  var profileData;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: CustomCacheManager.instance,
      imageUrl: (profileData ?? const {})['profile_image'] ??
          '$baseUrl/assets/images/no_profile.png',
      imageBuilder: (context, imageProvider) => Stack(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffFF530D),
                  Color(0xffFF960C)
                ], // Adjust colors as needed
              ),
            ),
            child: Center(
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFF2F3F5),
                    width: 1,
                  ),
                  image: DecorationImage(
                    image: imageProvider ??
                        AssetImage("assets/dp/blank-profile-picture-png.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      errorWidget: (context, url, error) => Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(
            color: Color(0xFFF2F3F5),
            width: 1,
          ),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(
                "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
