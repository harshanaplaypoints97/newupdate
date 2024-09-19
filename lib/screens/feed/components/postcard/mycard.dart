import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Mycard extends StatefulWidget {
  const Mycard({Key key}) : super(key: key);

  @override
  State<Mycard> createState() => _MycardState();
}

class _MycardState extends State<Mycard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [

            Container(),
            Row(
              children: [
                Container(),
                Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}