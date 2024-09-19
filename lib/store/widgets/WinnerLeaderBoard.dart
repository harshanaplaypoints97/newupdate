import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:play_pointz/Api/ApiV2/api_V2.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/LeaderBoardController.dart';
import 'package:play_pointz/screens/feed/feed_page.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../Provider/darkModd.dart';
import '../../models/NewModelsV2/store/resent_winners.dart';

class WinnerLeaderBoad extends StatelessWidget {
  const WinnerLeaderBoad({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder<ResentWinners>(
      future: ApiV2().getResentWinners(),
      builder: (context, AsyncSnapshot<ResentWinners> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLayout(context, darkModeProvider, width, height);
        } else if (snapshot.hasData && snapshot.data.body.orders.isNotEmpty) {
          return _buildContent(
              context, darkModeProvider, snapshot, width, height);
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[400],
            highlightColor: Colors.grey[300],
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildShimmerLayout(BuildContext context,
      DarkModeProvider darkModeProvider, double width, double height) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: darkModeProvider.isDarkMode
                  ? AppColors.darkmood.withOpacity(0.9)
                  : Color(0xffFFF2DA),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerBox(width * 0.2, height * 0.1),
                _buildShimmerBox(width * 0.3, height * 0.2),
                _buildShimmerBox(width * 0.2, height * 0.1),
              ],
            ),
          ),
          Container(
            color:
                darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
            height: 500,
            padding:
                EdgeInsets.only(top: 5, left: width * .02, right: width * .02),
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: _buildShimmerBox(double.infinity, 80),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DarkModeProvider darkModeProvider,
      AsyncSnapshot<ResentWinners> snapshot, double width, double height) {
    final onTertiary = Theme.of(context).colorScheme.onTertiary;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: darkModeProvider.isDarkMode
                  ? AppColors.darkmood.withOpacity(0.9)
                  : Color(0xffFFF2DA),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (snapshot.data.body.orders.length > 1)
                    _buildWinnerBox(snapshot.data.body.orders[1], 80, 80),
                  _buildWinnerBox(snapshot.data.body.orders[0], 140, 160),
                  if (snapshot.data.body.orders.length > 2)
                    _buildWinnerBox(snapshot.data.body.orders[2], 80, 80),
                ],
              ),
            ),
          ),
          Container(
            color:
                darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
            height: 500,
            padding:
                EdgeInsets.only(top: 5, left: width * .02, right: width * .02),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 15,
              separatorBuilder: (_, i) => i > 2
                  ? Divider(
                      color: darkModeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black26,
                      thickness: .5,
                      indent: width * 0.03,
                      endIndent: width * 0.03,
                    )
                  : const SizedBox(),
              itemBuilder: (context, index) {
                final leaderBoard = snapshot.data.body.orders[index];
                return index > 2
                    ? _buildLeaderBoardTile(
                        context, leaderBoard, width, height, darkModeProvider)
                    : const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerBox(Order order, double height, double width) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.network(
                order.item.imageUrl,
                fit: BoxFit.cover,
                height: height,
                width: width,
              ),
              Positioned(
                right: 10,
                bottom: 0,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    order.player.profileImage ??
                        "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
      ],
    );
  }

  Widget _buildLeaderBoardTile(BuildContext context, Order leaderBoard,
      double width, double height, DarkModeProvider darkModeProvider) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          flex: 9,
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(right: 10),
            title: Text(
              leaderBoard.player.fullName,
              style: TextStyle(
                color:
                    darkModeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            leading: Container(
              width: width * .12,
              height: height * .20,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  leaderBoard.player.profileImage ??
                      "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                ),
              ),
            ),
            trailing: SizedBox(
              width: 60,
              height: 100,
              child: Image.network(
                leaderBoard.item.imageUrl,
                fit: BoxFit.contain,
                height: 100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
