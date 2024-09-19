import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/models/login.dart';
import 'package:play_pointz/models/signUp.dart';
import 'package:play_pointz/screens/register/otp_page.dart';
import 'package:play_pointz/screens/register/register_screen_step_3.dart';
import 'package:play_pointz/screens/register/register_screen_step_01.dart';
import 'package:play_pointz/screens/register/register_screen_step_02.dart';
import 'package:play_pointz/widgets/common/loading_screen.dart';
import 'dart:math';

import '../../constants/page_transaction_router.dart';

class SocialRegisterPage extends StatefulWidget {
  SocialRegisterPage(
      {Key key,
      @required this.displayname,
      @required this.pf_image,
      @required this.email})
      : super(key: key);
  String displayname, pf_image, email;

  @override
  State<SocialRegisterPage> createState() => _SocialRegisterPageState();
}

class _SocialRegisterPageState extends State<SocialRegisterPage> {
  @override
  void initState() {
    // TODO: implement initState
    register();
  }

  int activeIndex = 0;
  final PageController pageController = PageController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController city = TextEditingController();
  String gender = "male";

  String deviceId = '';
  // String deviceId='';

  bool signingLoad = false;

  final _key = GlobalKey<FormState>();

  List<Widget> get SocialRegisterPages => [
        RegisterViewStep01(
          callback: navigateToPageOne,
          firstName: firstName,
          lastName: lastName,
          username: username,
          city: city,
        ),
        RegisterViewStep02(
          controller: email,
          setFemale: setFemale,
          setMale: setMale,
          pageTransfer: navigateToPageTwo,
          back: stepBack,
        ),
        RegisterViewStep03(
          password: password,
          confirmPassword: confirmPassword,
          action: register,
          back: stepBack,
          signingLoad: signingLoad,
        ),
      ];

  List<Map<String, String>> lottiePaths = [
    {"title": "Play Games", "path": "play_games.json"},
    {"title": "Buy Items", "path": "e-commerce.json"},
    {"title": "Win Items", "path": "game.json"},
  ];

  Future<void> navigateToPageOne() async {
    if (_key.currentState.validate()) {
      String name = "${firstName.text} ${lastName.text}".toLowerCase();
      if (name.contains("play points") ||
          name.contains("play pointz") ||
          name.contains("playpointz") ||
          name.contains("playpoints") ||
          name.contains("points play")) {
        Get.dialog(AlertDialog(
          title: Text(
              "You can't add names like PlayPointz, Play Points and PlayPoints etc..."),
        ));
      } else {
        /* setState(() {
          activeIndex = 1;
        }); */
        Login responce = await Api().checkUserName(username.text);
        if (responce.done) {
          setState(() {
            activeIndex = 1;
          });
        } else {
          Get.snackbar("Username exist", responce.message);
        }
      }
    }
  }

  getDeviceId() async {
    String devId = await PlatformDeviceId.getDeviceId;
    setState(() {
      deviceId = devId;
    });
  }

  void navigateToPageTwo() async {
    if (_key.currentState.validate()) {
      if (gender != "") {
        Login result = await Api().checkEmailDomain(email.text);
        if (result.done) {
          setState(() {
            activeIndex = 2;
          });
        } else {
          Get.snackbar("Hey", result.message);
        }
      } else {
        Get.snackbar("Hey", "Plase pick a gender");
      }
    }
  }

  void UserRegister() {}

  void stepBack() {
    setState(() {
      activeIndex--;
    });
  }

  void setMale() {
    setState(() {
      gender = "male";
    });
  }

  void setFemale() {
    setState(() {
      gender = "female";
    });
  }

  String Usename = "";
  String Password = "";

  void generateUsername(String displayName) {
    // Step 1: Reduce the displayName to a maximum of 5 characters
    String reducedName =
        displayName.length > 5 ? displayName.substring(0, 5) : displayName;

    // Step 2: Generate a random number to append
    int maxLength = 8;
    int randomNumberLength = maxLength - reducedName.length;
    String randomNumber = '';
    if (randomNumberLength > 0) {
      Random random = Random();
      randomNumber = random
          .nextInt(pow(10, randomNumberLength).toInt())
          .toString()
          .padLeft(randomNumberLength, '0');
    }

    // Step 3: Combine reducedName and randomNumber to form the final username
    String generatedUsername = reducedName + randomNumber;

    // Ensure the username length does not exceed 8 characters
    if (generatedUsername.length > maxLength) {
      generatedUsername = generatedUsername.substring(0, maxLength);
    }

    // Update the state and print the username
    setState(() {
      Usename = generatedUsername;
    });

    Logger().e(Usename); // Print the username to console
  }

  void generatePassword(String displayName, {int length = 10}) {
    // Define possible characters for the random part of the password (text and numbers only)
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const String numbers = '0123456789';

    // Step 1: Extract a part of the display name
    String namePart =
        displayName.length > 4 ? displayName.substring(0, 4) : displayName;

    Random random = Random();
    String randomPart;

    // Step 2: Generate the random part of the password, ensuring it contains at least one number
    do {
      randomPart = List.generate(length - namePart.length,
          (index) => chars[random.nextInt(chars.length)]).join();
    } while (!randomPart.contains(RegExp(r'[0-9]')));

    // Step 3: Combine the name part and random part
    String generatedPassword = namePart + randomPart;

    // Ensure the password length meets the specified length
    if (generatedPassword.length > length) {
      generatedPassword = generatedPassword.substring(0, length);
    }

    // Update the state and print the password
    setState(() {
      Password = generatedPassword;
    });

    Logger().e(Password); // Print the password to console using Logger
  }

  bool shouldLoad = false;

  Future<void> register() async {
    Logger().i(widget.displayname);
    generatePassword(widget.displayname);
    generateUsername(widget.displayname);
    await getDeviceId();

    Login responce = await Api().checkUserName(Usename);
    if (responce.done) {
      setState(() {
        signingLoad = true;
      });

      var token = await getPlayerPref(key: "ref_token");

      String refToken = token == "" ? null : token["ref_token"];

      NewSignUp signUp = await Api().playerSignUp(widget.email, Usename, gender,
          widget.displayname, Password, refToken, deviceId);
      if (signUp.done) {
        Navigator.pushReplacement(
            context,
            FadeTransitionRouter(
                child: OtpPage(
                    username: Usename,
                    password: Password,
                    uId: signUp.body.id)));
      } else {
        setState(() {
          signingLoad = false;
        });
        SnackBar snackBar = SnackBar(
          content: Text(
            "Signup failed.${signUp.message}",
            textAlign: TextAlign.center,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // setState(() {
      //   shouldLoad = true;
      // });

    } else {
      register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: shouldLoad
            ? const LoadingScreen()
            : Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    // PlayPointzLogoContainer(),
                    SizedBox(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: FittedBox(
                        child: Image.asset(
                          "assets/new/logo.png",
                          fit: BoxFit.cover,
                          // repeat: false,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "WellCome",
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.pf_image),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Text(
                      widget.displayname,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator.adaptive()),
                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      'Registering....',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: MediaQuery.of(context).size.height / 3,
                    //   child: Form(
                    //     key: _key,
                    //     // child: AnimatedSwitcher(
                    //     //   child: SocialRegisterPages[activeIndex],
                    //     //   duration: const Duration(milliseconds: 800),
                    //     // ),
                    //     child: PageView.builder(
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       itemCount: SocialRegisterPages.length,
                    //       itemBuilder: ((context, index) =>
                    //           SocialRegisterPages[activeIndex]),
                    //       onPageChanged: ((value) => setState(() {
                    //             activeIndex = value;
                    //           })),
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(
                      height: 16,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
