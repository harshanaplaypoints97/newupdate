import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../Provider/darkModd.dart';

Widget subScreenButton({
  context,
  BoxDecoration decoration,
  String displayText,
  FaIcon displayIcon,
  Function navigateScreen,
  // TextEditingController pwordController,
}) {
  final darkModeProvider = Provider.of<DarkModeProvider>(context);
  return Container(
    decoration: BoxDecoration(
        color: darkModeProvider.isDarkMode
            ? Color.fromARGB(255, 39, 38, 38)
            : Colors.white,
        // border: Border(
        //   bottom: BorderSide(
        //     color: Colors.grey[100],
        //   ),
        // ),
        borderRadius: darkModeProvider.isDarkMode
            ? BorderRadius.circular(20)
            : BorderRadius.circular(0)),
    child: ListTile(
      leading: displayIcon,
      title: Text(
        displayText,
        style: TextStyle(
            color: darkModeProvider.isDarkMode ? Colors.white : Colors.black),
      ),
      onTap: () {
        navigateScreen();
      },
    ),
  );
}

Widget subScreenButton2({
  context,
  BoxDecoration decoration,
  String displayText,
  FaIcon displayIcon,
  Function navigateScreen,
  // TextEditingController pwordController,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.red,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey[100],
        ),
      ),
    ),
    child: ListTile(
      leading: displayIcon,
      title: Text(
        displayText,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        navigateScreen();
      },
    ),
  );
}

Widget subScreenButtonProfile({
  context,
  BoxDecoration decoration,
  String displayText,
  FaIcon displayIcon,
  Function navigateScreen,
  // TextEditingController pwordController,
}) {
  final darkModeProvider = Provider.of<DarkModeProvider>(context);
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey[100],
        ),
      ),
    ),
    child: ListTile(
      leading: displayIcon,
      trailing: Icon(Icons.arrow_forward_ios),
      title: Text(
        displayText,
        style: TextStyle(
            color: darkModeProvider.isDarkMode ? Colors.white : Colors.black),
      ),
      onTap: () {
        navigateScreen();
      },
    ),
  );
}
