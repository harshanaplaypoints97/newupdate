import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:play_pointz/models/login.dart';
import 'package:play_pointz/screens/about_us/about_us_screen.dart';
import 'package:play_pointz/screens/connect/connect.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/home/splash_screen.dart';
import 'package:play_pointz/screens/orders/my_orders.dart';
import 'package:play_pointz/screens/profile/Edit%20Profile%20Sections/Main_edit_profile.dart';
import 'package:play_pointz/screens/profile/Edit%20Profile%20Sections/my_information.dart';
import 'package:play_pointz/screens/profile/login_and_security.dart';
import 'package:play_pointz/screens/profile/profile.dart';
import 'package:play_pointz/screens/profile/settings.dart';
import 'dart:io' as Io;

import 'package:play_pointz/screens/profile/support.dart';

import 'package:play_pointz/screens/register/Privacy_policy/privacy_policy.dart';
import 'package:play_pointz/screens/register/delivery_terms.dart';
import 'package:play_pointz/screens/register/terms_conditions.dart';
import 'package:play_pointz/services/image_cropper/image_cropper.dart';
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

import '../../../Provider/darkModd.dart';
import '../../../models/home/UnReadNoti.dart';
import '../../../models/update_acc_images.dart';

class NewSettings extends StatefulWidget {
  NewSettings({Key key, this.unreadNotifications}) : super(key: key);
  String unreadNotifications;

  @override
  State<NewSettings> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<NewSettings> {
  bool myData = false;
  var profileData;
  getPlayerDetailsa() async {
    await HandleApi().getPlayerProfileDetails();
    profileData = await getPlayerPref(key: "playerProfileDetails");

    // setState(() {
    //   myData = true;
    // });
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

  PickedFile profilImage;
  PickedFile coverImage;

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

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

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

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      backgroundColor:
          darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 75,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffffd9c4),
                            Color(0xffffc2b2),
                            Color(0xffFFAEA2)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            profileName(
                                name: userController.currentUser.value.fullName
                                        .substring(0, 10) ??
                                    ""),
                            userController.currentUser.value.username == null
                                ? Container()
                                : userLocation(
                                    name:
                                        "@${userController.currentUser.value.username}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -8,
                    left: 10,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.10,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: MediaQuery.of(context).size.width * 0.095,
                        backgroundImage: NetworkImage(
                          userController.currentUser.value.profileImage ??
                              "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: -5,
                      left: 50,
                      child: InkWell(
                        onTap: () {
                          _showChoiceDialog(context, 'profile', true);
                        },
                        child: Container(
                          padding: EdgeInsetsDirectional.all(2),
                          decoration: BoxDecoration(
                              color: AppColors.PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              FontAwesomeIcons.camera,
                              color: AppColors.WHITE,
                              size: 15,
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 10,
                      right: 15,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyInformation(),
                              ));
                        },
                        child: Icon(
                          FontAwesomeIcons.userEdit,
                          color: Color(0xffBC5B5B),
                          size: 20,
                        ),
                      ))
                ],
              ),

              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffBEFEB9),
                            borderRadius: BorderRadius.circular(12)),
                        height: 40,
                        width: 120,
                        child: Center(
                          child: Text(
                            userController.currentUser.value.correctAnswers
                                .toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Correct Answers",
                        style: TextStyle(
                            color: darkModeProvider.isDarkMode
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black,
                            fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffFEB9B9),
                            borderRadius: BorderRadius.circular(12)),
                        height: 40,
                        width: 120,
                        child: Center(
                          child: Text(
                            userController.currentUser.value.incorrectAnswers
                                .toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Incorrect Answers",
                        style: TextStyle(
                            color: darkModeProvider.isDarkMode
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black,
                            fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              //Settings ShortCuts

              Text(
                "Settings shortcuts",
                style: TextStyle(
                    color: darkModeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.8)
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),

              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: darkModeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.8)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShortcutContainer(
                        size: 20,
                        icon: FontAwesomeIcons.gift,
                        name: 'Redeemed',
                        ontap: () {
                          DefaultRouter.defaultRouter(
                              MyOrders(fromProfile: true, onPostCreate: () {}),
                              context);
                        },
                      ),
                      ShortcutContainer(
                        size: 20,
                        icon: FontAwesomeIcons.key,
                        name: 'Password',
                        ontap: () {
                          DefaultRouter.defaultRouter(
                              LoginAndSecurity(), context);
                        },
                      ),
                      ShortcutContainers(
                        size: 20,
                        icon: FontAwesomeIcons.walking,
                        name: 'Referral',
                        ontap: () {
                          DefaultRouter.defaultRouter(ConnectPage(), context);
                        },
                      ),
                      ShortcutContainer(
                        size: 20,
                        icon: FontAwesomeIcons.lock,
                        name: 'Privacy',
                        ontap: () {
                          DefaultRouter.defaultRouter(PrivacyPolicy(), context);
                        },
                      ),
                      ShortcutContainer(
                        size: 30,
                        icon: Icons.settings,
                        name: 'Settings',
                        ontap: () {
                          DefaultRouter.defaultRouter(
                              Settings(
                                  unreadNotifications:
                                      widget.unreadNotifications),
                              context);
                        },
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Text(
                "My Wallet",
                style: TextStyle(
                    color: darkModeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.8)
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),

              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Color(0xfff38d2a),
                      //     Color(0xfffd6013)
                      //   ], // Change these to your desired colors
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      // ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    userController
                                                .currentUser.value.fullName.length >
                                            20
                                        ? userController
                                                .currentUser.value.fullName
                                                .substring(0, 20) +
                                            "..."
                                        : userController
                                                .currentUser.value.fullName ??
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 90,
                                child: Image(
                                  image:
                                      AssetImage("assets/logos/whitelogo.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "PTZ .",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    userController.currentUser.value.points
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
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
              ),

              SizedBox(
                height: 20,
              ),

//Harshana Devolopment  upper part R*
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: GestureDetector(
              //     onTap: () {
              //       // DefaultRouter.defaultRouter(ProfileNew(), context);
              //       DefaultRouter.defaultRouter(
              //         Profile(
              //           myProfile: true,
              //         ),
              //         context,
              //       );
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: Colors.white,
              //       ),
              //       height: 90,
              //       width: double.infinity,
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 15),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             //Profile Image
              //             // ProfileImage(profileData: profileData),
              //             ClipOval(
              //               child: CachedNetworkImage(
              //                 cacheManager: CustomCacheManager.instance,
              //                 imageUrl:
              //                     userController.currentUser.value.profileImage,
              //                 width: 50.w,
              //                 height: 50.w,
              //                 fit: BoxFit.fill,
              //                 fadeInDuration: const Duration(milliseconds: 600),
              //                 fadeOutDuration: const Duration(milliseconds: 600),
              //                 errorWidget: (a, b, c) {
              //                   return CachedNetworkImage(
              //                     cacheManager: CustomCacheManager.instance,
              //                     imageUrl:
              //                         "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
              //                   );
              //                 },
              //               ),
              //             ),

              //             SizedBox(
              //               width: 20,
              //             ),

              //             Spacer(),
              //             NotificationButton(
              //               unReadNotificationCount: widget.unreadNotifications,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //       context: context,
              //       displayText: "Change Password",
              //       displayIcon: FaIcon(FontAwesomeIcons.shieldAlt),
              //       navigateScreen: () {
              //         DefaultRouter.defaultRouter(LoginAndSecurity(), context);
              //       }),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //       context: context,
              //       displayText: "Connect",
              //       displayIcon: FaIcon(FontAwesomeIcons.shareAlt),
              //       navigateScreen: () {
              //         DefaultRouter.defaultRouter(ConnectPage(), context);
              //       }),
              // ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //       context: context,
              //       displayText: "Contact Support",
              //       displayIcon: FaIcon(FontAwesomeIcons.microphone),
              //       navigateScreen: () {
              //         DefaultRouter.defaultRouter(SupportPage(), context);
              //       }),
              // ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //     context: context,
              //     displayText: "About Us",
              //     displayIcon: FaIcon(Icons.report),
              //     navigateScreen: () => {
              //       DefaultRouter.defaultRouter(AboutUsScreen(), context),
              //     },
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //     context: context,
              //     displayText: "Privacy Policy",
              //     displayIcon: FaIcon(Icons.privacy_tip_sharp),
              //     navigateScreen: () => {
              //       DefaultRouter.defaultRouter(PrivacyPolicy(), context),
              //     },
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //     context: context,
              //     displayText: "Terms & Conditions",
              //     displayIcon: FaIcon(Icons.fact_check),
              //     navigateScreen: () => {
              //       DefaultRouter.defaultRouter(TermsConditions(), context),
              //     },
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //     context: context,
              //     displayText: "Delivery Terms & Conditions",
              //     displayIcon: FaIcon(Icons.delivery_dining),
              //     navigateScreen: () => {
              //       DefaultRouter.defaultRouter(
              //           DeliveryTermsConditions(), context),
              //     },
              //   ),
              // ),

              // // SizedBox(
              // //   height: 5,
              // // ), // Spacer(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: subScreenButton(
              //       context: context,
              //       displayText: "Log out",
              //       displayIcon: FaIcon(FontAwesomeIcons.signOutAlt),
              //       navigateScreen: () => alertDialog(
              //             loading: btnLoading,
              //             context: context,
              //             function: () async {
              //               setState(() {
              //                 btnLoading = true;
              //               });

              //               LogOut result = await Api().PlayerLogOut();
              //               if (result.done) {
              //                 await SendUser().deleteDeviceToken();
              //                 removePlayerPref(key: "playerProfileDetails");
              //                 Get.deleteAll();

              //                 setState(() {
              //                   btnLoading = false;
              //                 });
              //                 final prefManager =
              //                     await SharedPreferences.getInstance();
              //                 await prefManager.clear();
              //                 Restart.restartApp();
              //                 socket.dispose();
              //                 Navigator.pushAndRemoveUntil(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (BuildContext context) =>
              //                         MainSplashScreen(),
              //                   ),
              //                   (route) => false,
              //                 );
              //               } else {
              //                 setState(() {});
              //               }
              //             },
              //           )),
              // ),

              // SizedBox(
              //   height: 80,
              // ), // Spacer(),
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

class ShortcutContainer extends StatelessWidget {
  String name;
  IconData icon;
  VoidCallback ontap;
  double size;
  ShortcutContainer({
    @required this.icon,
    @required this.name,
    @required this.ontap,
    @required this.size,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xffFEDAB9)),
            child: Icon(
              icon,
              size: size,
              color: Color(0xffFF7A00),
            ),
          ),
          Text(
            name,
            style: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class ShortcutContainers extends StatelessWidget {
  String name;
  IconData icon;
  VoidCallback ontap;
  double size;
  ShortcutContainers({
    @required this.icon,
    @required this.name,
    @required this.ontap,
    @required this.size,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xffFEDAB9)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage("assets/logos/Connect.png"),
                height: 10,
                width: 10,
              ),
            ),
          ),
          Text(
            name,
            style: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
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
