// import 'dart:async';
// import 'dart:math';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';
// import 'package:platform_device_id/platform_device_id.dart';
// import 'package:play_pointz/Api/Api.dart';

// class SpinnerGame extends StatefulWidget {
//   const SpinnerGame({Key key}) : super(key: key);

//   @override
//   State<SpinnerGame> createState() => _SpinnerGameState();
// }

// class _SpinnerGameState extends State<SpinnerGame> {
//   String hmac = "";
//   //Hmac Genarate Method

//   String generateHmac(String timestamp, String data, String deviceid) {
//     var key = utf8.encode(deviceid); // your secret key
//     var message = utf8.encode('$timestamp.$data');

//     var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
//     var digest = hmacSha256.convert(message);

//     return digest.toString();
//   }

//   String generateHmacs(String data, String secretKey) {
//     // Get current timestamp in seconds
//     int timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

//     // Create the data string
//     String message = "$timestamp.$data";

//     // Create a HMAC SHA256 hash using the secret key
//     Hmac hmacSha256 = Hmac(sha256, utf8.encode(secretKey));
//     Digest hmacDigest = hmacSha256.convert(utf8.encode(message));

//     // Convert the digest to a hexadecimal string
//     String hashHmacSHA256 = hmacDigest.toString();

//     // Log the timestamp and HMAC hash
//     print('Timestamp: $timestamp');
//     print('HMAC Hash: $hashHmacSHA256');

//     // Return the HMAC hash
//     return hashHmacSHA256;
//   }

//   //////////////////////////////////////////////////////////////////////////////////////////
//   ///
//   ///
//   ///

//   final audio = AudioPlayer();
//   final StreamController _dividerController = StreamController<int>();

//   final _wheelNotifier = StreamController<double>();

//   dispose() {
//     _dividerController.close();
//     _wheelNotifier.close();
//     audio.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(backgroundColor: Color(0xffDDC3FF), elevation: 0.0),
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(
//                   'assets/bg/spinnerbg.jpg'), // Replace 'image_name.png' with your image asset path
//               fit: BoxFit.cover, // Adjust the fit as needed
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 30),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
//                   child: Image.asset('assets/bg/spin_title.png'),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 8,
//                 ),
//                 SpinningWheel(
//                   Image.asset('assets/bg/roulette-8-300.png'),
//                   width: 310,
//                   height: 310,
//                   initialSpinAngle: _generateRandomAngle(),
//                   spinResistance: 0.8,
//                   canInteractWhileSpinning: false,
//                   dividers: 8,
//                   onUpdate: _dividerController.add,
//                   onEnd: _dividerController.add,
//                   secondaryImage:
//                       Image.asset('assets/bg/roulette-center-300.png'),
//                   secondaryImageHeight: 50,
//                   secondaryImageWidth: 110,
//                   shouldStartOrStop: _wheelNotifier.stream,
//                   secondaryImageTop: 0,
//                 ),
//                 SizedBox(height: 30),
//                 // StreamBuilder(
//                 //   stream: _dividerController.stream,
//                 //   builder: (context, snapshot) => snapshot.hasData
//                 //       ? RouletteScore(snapshot.data)
//                 //       : Container(),
//                 // ),
//                 // SizedBox(height: 30),

//                 InkWell(
//                   onTap: () async {
//                     //Device Id

//                     String devId = await PlatformDeviceId.getDeviceId;

//                     //Timestamp

//                     final timestamp =
//                         (DateTime.now().millisecondsSinceEpoch / 1000).floor();

//                     var combinedData =
//                         '$timestamp' + "." + '{ "action": "add", "points": 5 }';

//                     //Genarate Hmac
//                     setState(() {
//                       hmac = generateHmacs(combinedData, devId);
//                     });

//                     //End Point Calling Method

//                     Api().pointzaddmetrhod("add", 5, timestamp.toString(),
//                         hmac.toString(), context);

//                     // audio.play(AssetSource("audio/spinsound.mp3"));
//                     // _wheelNotifier.sink.add(_generateRandomVelocity());
//                     // await Future.delayed(Duration(seconds: 8));

//                     // _wheelNotifier.onPause;
//                     // audio.stop();

//                     void method() {
//                       print("snshgd ");
//                     }
//                   },
//                   child: Container(
//                     height: 100,
//                     width: 200,
//                     child: Image.asset('assets/bg/spin.png'),
//                   ),
//                 )
//                 // ElevatedButton(
//                 //   child: new Text("Start"),
//                 //   onPressed: () =>
//                 //       _wheelNotifier.sink.add(_generateRandomVelocity()),
//                 // )'
//                 //hshshsmmnsjxgxn xhxtxnnnbbb
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   double _generateRandomVelocity() => (Random().nextDouble() * 100000) + 20000;

//   double _generateRandomAngle() => Random().nextDouble() * pi * 2;
// }

// class RouletteScore extends StatelessWidget {
//   final int selected;

//   final Map<int, String> labels = {
//     1: '1000\$',
//     2: '400\$',
//     3: '800\$',
//     4: '7000\$',
//     5: '5000\$',
//     6: '300\$',
//     7: '2000\$',
//     8: '100\$',
//   };

//   RouletteScore(this.selected);

//   @override
//   Widget build(BuildContext context) {
//     return Text('${labels[selected]}',
//         style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0));
//   }
// }
