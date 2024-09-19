import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

//FireBase Fcm Token Get Method

Future<String> getFcmToken() async {
  if (Platform.isAndroid) {
    String fcmKey = await FirebaseMessaging.instance.getToken();

    print("Fcm Key IS " + fcmKey);
    return fcmKey;
  }
  String fcmKey = await FirebaseMessaging.instance.getToken();
  return fcmKey;
}

SendPushNotification(
    String fcmkey, String title, String message, BuildContext context) async {
  Map data = {
    'to': fcmkey,
    'notification': {
      'title': title,
      'body': message,
    },
  };
  print("post data $data");

  String body = json.encode(data);
  // ignore: prefer_interpolation_to_compose_strings
  var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  var response = await http.post(
    url,
    body: body,
    headers: {
      "Content-Type": "application/json",
      "Authorization":
          "AAAAdhAK8rM:APA91bEN43pzSw3jUMOR9ApLBzWfyGuub2_DI34Occ_MPO2k47IsTgRyXUtgVFiwqi3sJulMKJkPA6cW-ZRJkYK5jyKpt3gH6ydYj1pPY0rnmgTAIVylEMtlsT7tsNzg8VOm1xe5BKtO",
    },
  );
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    // Logger().i('Push Notification Sucessfully');
  } else {
    // Logger().e('error');

  }
}
