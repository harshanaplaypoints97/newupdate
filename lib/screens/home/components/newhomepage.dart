import 'dart:async';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/models/check_plyer_login.dart';
import 'package:play_pointz/screens/home/components/newhome_page.dart';
import 'package:play_pointz/screens/home/components/newhomepage.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/new_login/new_login_screen.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../../constants/page_transaction_router.dart';

class newhomescreen extends StatefulWidget {
  const newhomescreen({Key key}) : super(key: key);

  @override
  _newhomescreenState createState() => _newhomescreenState();
}

class _newhomescreenState extends State<newhomescreen> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  int index = 0;

  bool isNotify = false;
  bool verifiedUser = false;
  var message;
  bool isBannedUser = false;

  String newVersion;
  bool isUpdateAvailable;
  String localVersion;

  String deviceId = '';

  Timer timer;

  @override
  void initState() {
    super.initState();
  }

  //Auto Navigate to login register page

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(60),
              child: Image.asset(
                "assets/new/logo.png",
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              bottom: size.height * 0.1,
              child: SizedBox(
                width: size.width * 0.3,
                child: Image.asset(
                  "assets/logos/from-avanux-gray.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  height: 25,
                  width: size.width,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        "PlayPointz",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.sp,
                            fontFamily: "Inter"),
                      ),
                      Spacer(),
                      Text(
                        'Version ' + '2.0.1',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.sp,
                            fontFamily: "Inter"),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
