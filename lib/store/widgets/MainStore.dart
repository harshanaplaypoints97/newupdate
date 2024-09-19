import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:provider/provider.dart';

import '../../Provider/darkModd.dart';
import '../../controllers/user_controller.dart';
import '../main Store/Markert Place/screens/MainMarkertPlace.dart';
import '../store.dart';
import 'WinnerLeaderBoard.dart';

class MainStore extends StatefulWidget {
  const MainStore({Key key}) : super(key: key);

  @override
  State<MainStore> createState() => _MainStoreState();
}

class _MainStoreState extends State<MainStore> with TickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // Set this to your desired height
        child: AppBar(
          elevation: 0,
          backgroundColor:
              darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.white,
            controller: _tabController, // Add this line
            tabs: userController.currentUser.value.is_brand_acc
                ? <Widget>[
                    Tab(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: _selectedIndex == 1
                                ? Color(0xffFF681B)
                                : Color(0xffffebe1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "MarketPlace",
                          style: TextStyle(
                              fontSize: 10,
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Color(0xffFF681B),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]
                : <Widget>[
                    Tab(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: _selectedIndex == 0
                                ? Color(0xffFF681B)
                                : Color(0xffffebe1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Play Store",
                          style: TextStyle(
                              fontSize: 10,
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Color(0xffFF681B),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: _selectedIndex == 1
                                ? Color(0xffFF681B)
                                : Color(0xffffebe1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "MarketPlace",
                          style: TextStyle(
                              fontSize: 10,
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Color(0xffFF681B),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: _selectedIndex == 2
                                ? Color(0xffFF681B)
                                : Color(0xffffebe1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "LeaderBoard",
                          style: TextStyle(
                              fontSize: 10,
                              color: _selectedIndex == 2
                                  ? Colors.white
                                  : Color(0xffFF681B),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
      body: userController.currentUser.value != null
          ? userController.currentUser.value.is_brand_acc
              ? TabBarView(controller: _tabController, // Add this line
                  children: [
                      MainMarkertPlace(),
                    ])
              : TabBarView(
                  controller: _tabController, // Add this line
                  children: [
                    StorePage(),
                    MainMarkertPlace(),
                    WinnerLeaderBoad(),
                  ],
                )
          : Scaffold(
              body: Center(
                child: CupertinoActivityIndicator(
                  radius: 15.0, // You can adjust the radius to change the size
                ),
              ),
            ),
    );
  }
}
