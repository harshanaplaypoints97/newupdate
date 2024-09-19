import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';

import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/constants/page_transaction_router.dart';
import 'package:play_pointz/models/login.dart';
import 'package:play_pointz/models/send_mail_to_reset_pass.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/new_login/forget_password_view.dart';
import 'package:play_pointz/screens/register/otp_page.dart';
import 'package:play_pointz/screens/register/register_screen.dart';
import 'package:play_pointz/services/firebase_service.dart';
import 'package:provider/provider.dart';

import '../../controllers/user_controller.dart';

class SocialNewLogin extends StatefulWidget {
  String Email, ProfileImage;
  SocialNewLogin({Key key, @required this.Email, @required this.ProfileImage})
      : super(key: key);

  @override
  State<SocialNewLogin> createState() => _SocialNewLoginState();
}

class _SocialNewLoginState extends State<SocialNewLogin> {
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool shouldLoad = false;

  bool shouldVisible = false;

  Timer timer;

  UserController userController = Get.put(UserController());

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.Email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // PlayPointzLogoContainer(),
                SizedBox(
                  height: 80,
                ),
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
                  "Welcome",
                  style: TextStyle(fontSize: 18.sp),
                ),
                const SizedBox(
                  height: 16,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16),
                //   child: SizedBox(
                //     height: 200.h,
                //     width: MediaQuery.of(context).size.width,
                //     child: FittedBox(
                //       child: Image.asset(
                //         "assets/new/login.png",
                //         // repeat: false,
                //       ),
                //     ),
                //   ),
                // ),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(widget.ProfileImage),
                ),

                SizedBox(
                  height: 40,
                ),

                inputField(userNameController, "Username / Email",
                    enabled: false),
                const SizedBox(
                  height: 8,
                ),
                inputField(passwordController, "Password",
                    isPassword: shouldVisible),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        DefaultRouter.defaultRouter(
                            ForgetPasswordView(), context);
                      },
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                shouldLoad
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      )
                    : MaterialButton(
                        color: AppColors.PRIMARY_COLOR,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        onPressed: () async {
                          if (_key.currentState.validate()) {
                            setState(() {
                              shouldLoad = true;
                            });
                            Login login = await Api().loginApi(
                                userNameController.text,
                                passwordController.text);
                            if (login.done) {
                              await HandleApi().getPlayerProfileDetails();
                              var profileData = await getPlayerPref(
                                  key: "playerProfileDetails");
                              if (profileData["is_verified"]) {
                                Get.off(() => HomePage(
                                      activeIndex: 0,
                                    ));
                                SendUser().saveDeviceToken("id");
                              } else {
                                SendMailToResetPass result =
                                    await Api().resendOtp(profileData["id"]);
                                if (result.done) {
                                  debugPrint(result.message);
                                  Navigator.pushReplacement(
                                      context,
                                      FadeTransitionRouter(
                                          child: OtpPage(
                                              username: userNameController.text,
                                              password: passwordController.text,
                                              uId: profileData["id"])));
                                }
                              }
                            } else {
                              setState(() {
                                shouldLoad = false;
                              });
                              SnackBar snackBar = SnackBar(
                                  content: Text(
                                "Login failed, ${login.message}",
                                textAlign: TextAlign.center,
                              ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                          setState(() {
                            shouldLoad = false;
                          });
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        height: kToolbarHeight,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(TextEditingController controller, String hintTetx,
      {bool isPassword = false, bool enabled = true}) {
    return TextFormField(
      enabled: enabled,
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
      maxLength: 30,
      buildCounter: (BuildContext context,
              {int currentLength, int maxLength, bool isFocused}) =>
          null,
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
