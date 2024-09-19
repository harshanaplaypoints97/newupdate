import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:play_pointz/Api/ApiV2/api_V2.dart';
import 'package:play_pointz/models/NewModelsV2/store/resent_winners.dart';
import 'package:play_pointz/screens/shimmers/shimmer_post_card.dart';

import 'package:play_pointz/store/widgets/resent_winer_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../Provider/darkModd.dart';

class RecentWinnersContainer extends StatelessWidget {
  const RecentWinnersContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResentWinners>(
        future: ApiV2().getResentWinners(),
        builder: (context, AsyncSnapshot<ResentWinners> snapshot) {
          if (snapshot.hasData && snapshot.data.body.orders.isNotEmpty) {
            return Container(
              child: CarouselSlider.builder(
                options: CarouselOptions(
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 1500),
                    aspectRatio: 15 / 6,
                    autoPlay: true,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {}),
                itemCount: snapshot.data.body.orders.length,
                itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) =>
                    SizedBox(
                        child: ResentWinnersCard(
                            snapshot.data.body.orders[itemIndex].player
                                .profileImage,
                            snapshot
                                .data.body.orders[itemIndex].player.fullName,
                            snapshot.data.body.orders[itemIndex].item.imageUrl,
                            snapshot.data.body.orders[itemIndex].item.name)),
              ),
            );
          } else {
            return Shimmer.fromColors(
              baseColor: Colors.grey[400],
              highlightColor: Colors.grey[300],
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100.0),
                        bottomLeft: Radius.circular(100),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget noItems(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Image.asset("assets/new/be-the-first-winner.png"),
        height: 100,
      ),
    );
  }
}
