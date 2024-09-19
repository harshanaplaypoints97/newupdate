import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:play_pointz/Provider/darkModd.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
import 'package:play_pointz/screens/about_us/about_us_screen.dart';
import 'package:play_pointz/screens/friends/friends_screen.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/home/notifications.dart';
import 'package:play_pointz/screens/home/splash_screen.dart';
import 'package:play_pointz/screens/new_login/new_login_screen.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:play_pointz/screens/orders/my_orders.dart';
import 'package:play_pointz/screens/play/play_new.dart';
import 'package:play_pointz/screens/profile/login_and_security.dart';
import 'package:play_pointz/screens/profile/support.dart';
import 'package:play_pointz/store/main%20Store/Play%20Mart/provider/PlayMartProvider.dart';
import 'package:play_pointz/store/store.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:provider/provider.dart';
import 'Provider/Profile_Complete_Provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> requestATT() async {
  // Check the current status of the permission
  final status = await AppTrackingTransparency.trackingAuthorizationStatus;

  // If not determined, request permission
  if (status == TrackingStatus.notDetermined) {
    final result = await AppTrackingTransparency.requestTrackingAuthorization();
    if (result == TrackingStatus.authorized) {
      // Permission granted, you can collect tracking data here
      print("Tracking authorized");
    } else {
      // Permission denied, handle accordingly
      print("Tracking not authorized");
    }
  }
}

// void main() async {
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  requestATT();

  final PendingDynamicLinkData initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  if (initialLink != null) {}

  FirebaseDynamicLinks.instance.onLink.listen(
    (pendingDynamicLinkData) {
      // Set up the `onLink` event listener next as it may be received here
      if (pendingDynamicLinkData != null) {
        final Uri deepLink = pendingDynamicLinkData.link;
        if (deepLink != null) {
          updatePlayerPref(
              key: 'ref_token',
              data: {'ref_token': deepLink.queryParameters["token"]});
        } else {
          updatePlayerPref(key: 'ref_token', data: {'ref_token': null});
        }
      }
    },
  );

  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(),
  );

  runApp(MyApp(initialLink: initialLink));
}

class MyApp extends StatefulWidget {
  final PendingDynamicLinkData initialLink;

  const MyApp({Key key, this.initialLink}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

final _navigatorKey = GlobalKey<NavigatorState>();

AppLinks _appLinks;
StreamSubscription<Uri> _linkSubscription;

class _MyAppState extends State<MyApp> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final facebookAppEvents = FacebookAppEvents();

  void initDynamicLink() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      var str = dynamicLinkData.link.queryParameters["token"];
      // print(dynamicLinkData.)
      updatePlayerPref(key: 'ref_token', data: {'ref_token': str});
      if (str == null || str == "") {
        updatePlayerPref(key: 'ref_token', data: {'ref_token': null});
        // messageToastGreen("Invalid token");
      }
    }).onError((error) {});
  }

  void initDeepLinks() async {
    _appLinks = AppLinks();

    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      // debugPrint('getInitialAppLink: $appLink');
      openAppLink(appLink);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) async {
    var queryParams = uri.queryParameters;
    if (queryParams['type'] == 'forgot') {
      if (queryParams['status'] == "true" && queryParams['message'] != null) {
        _navigatorKey.currentState?.pushReplacementNamed('login');
        updatePlayerPref(
          key: "PlayerToken",
          data: queryParams["token"],
        );
        messageToastGreen(queryParams['message']);
      }
    }
  }

  @override
  void initState() {
    facebookAppEvents.logEvent(
      name: 'button_clicked',
      parameters: {
        'button_id': 'main',
      },
    );
    if (widget.initialLink != null) {
      var str = widget.initialLink.link.queryParameters["token"];
      updatePlayerPref(key: 'ref_token', data: {'ref_token': str});
      // initDynamicLink();
    } else {
      updatePlayerPref(key: 'ref_token', data: {'ref_token': null});

      // initDeepLinks();
    }

    super.initState();
  }

  final u = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlayMartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => profileComplete(),
        ),
        ChangeNotifierProvider(
          create: (context) => DarkModeProvider()..loadDarkMode(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(411.4, 820.6),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BackGestureWidthTheme(
              backGestureWidth: BackGestureWidth.fraction(1 / 2),
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: _navigatorKey,
                initialRoute: '/',
                routes: {
                  '/': (context) => MainSplashScreen(),
                  'login': (context) => NewLoginScreen(),
                  "/settings": (context) => HomePage(activeIndex: 0),
                  "/store": (context) => StorePage(),
                  "/play": (context) => PlayPage(
                        cointBalanceUpdater: () {},
                      ),
                  "/notifications": (context) => Notifications(),
                  "/about": (context) => AboutUsScreen(),
                  "/orders": (context) => MyOrders(
                        fromProfile: true,
                      ),
                  "/support": (context) => SupportPage(),
                  "/change-password": (context) => LoginAndSecurity(),
                  "/friends": (context) => FriendsScreen(),
                },
                title: 'Play Pointz',
                theme: ThemeData(
                  primarySwatch: Colors.orange,
                  fontFamily: 'Inter',
                  pageTransitionsTheme: PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android:
                          FadeUpwardsPageTransitionsBuilder(),
                      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}
