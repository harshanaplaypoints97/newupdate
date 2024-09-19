import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/Api/ApiV2/api_V2.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/item_label_controller.dart';
import 'package:play_pointz/models/store/upcomming_item_model.dart';
import 'package:play_pointz/screens/Items/item_screen.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/widgets/store/time_btn.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../Provider/darkModd.dart';

class OtherItemWidget extends StatefulWidget {
  final UpCommingItem item;
  String current;

  OtherItemWidget({Key key, this.item, this.current}) : super(key: key);

  @override
  State<OtherItemWidget> createState() => _OtherItemWidgetState();
}

class _OtherItemWidgetState extends State<OtherItemWidget> {
  DateTime _now;
  DateTime _auction;
  DateTime _start;
  Timer _timer;
  Duration difference;
  Duration difference2;
  bool _isLoading = true; // Loading flag

  @override
  void initState() {
    super.initState();

    // Initialize times
    _now = DateTime.parse(widget.current) ?? DateTime.now();
    _auction = DateTime.parse(widget.item.endTime);
    _start = DateTime.parse(widget.item.startTime);

    // Timer to update the current time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        widget.current = DateTime.parse(widget.current)
            .add(const Duration(seconds: 1))
            .toString();
        _now = DateTime.parse(widget.current) ?? DateTime.now();

        if (_auction.isBefore(_now)) {
          timer.cancel();
        }
      });
    });

    // Ensure the shimmer effect is visible immediately
    setState(() {
      _isLoading = true;
    });

    // Simulate network loading delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    setState(() {
      difference = _auction.difference(_now);
      difference2 = _start.difference(_now);
    });
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          height: 300.h,
          width: (MediaQuery.of(context).size.width - 40) / 2,
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
        ),
      );
    }
    return InkWell(
      onTap: () {
        // print(ApiV2().getResentWinners());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemView(
                      newitemdata: widget.item,
                      current: widget.current,
                    )));
      },
      child: Container(
        height: 300.h,
        width: (MediaQuery.of(context).size.width - 40) / 2,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        // padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: darkModeProvider.isDarkMode
              ? Color.fromARGB(255, 42, 42, 42).withOpacity(0.8)
              : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 70,
                    decoration: BoxDecoration(
                        color: ItemLabelController().itemLabel(difference,
                            widget.item.itemQuantity, difference2)["color"],
                        borderRadius: BorderRadius.circular(21)),
                    child: Center(
                      child: Text(
                        ItemLabelController().itemLabel(difference,
                            widget.item.itemQuantity, difference2)["lable"],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ////////////////////////////////////////////////////////////////jjjjjj

                  // Chip(
                  //   label: Text(
                  //     ItemLabelController().itemLabel(difference,
                  //         widget.item.itemQuantity, difference2)["lable"],
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   backgroundColor: ItemLabelController().itemLabel(difference,
                  //       widget.item.itemQuantity, difference2)["color"],
                  // ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: darkModeProvider.isDarkMode
                        ? AppColors.darkmood.withOpacity(0.2)
                        : Color(0xffFFECEC),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Positioned(
                  top: 0, // Aligning the image within the container
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CachedNetworkImage(
                    height: 120, // Ensure this matches the container's height
                    width: 120, // Ensure this matches the container's width
                    cacheManager: CustomCacheManager.instance,
                    imageUrl: widget.item.imageUrl,
                    fit: BoxFit
                        .cover, // Ensures the image covers the entire container
                    errorWidget: (context, url, error) {
                      Future.delayed(Duration(seconds: 5), () {
                        setState(() {
                          // Trigger a rebuild
                        });
                      });
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xffC4C4C4).withOpacity(0.3),
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: darkModeProvider.isDarkMode
                              ? AppColors.darkmood.withOpacity(0.2)
                              : Color(0xffC4C4C4).withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Expanded(child: Container()),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      color: darkModeProvider.isDarkMode
                          ? AppColors.darkmood.withOpacity(0.5)
                          : Colors.white),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.item.name,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        style: TextStyle(
                          color: darkModeProvider.isDarkMode
                              ? Colors.white
                              : Color(0xff373737),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "PTZ ${widget.item.priceInPoints}",
                              // text: _now.toLocal.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.PRIMARY_COLOR_LIGHT,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            /* TextSpan(
                              text:
                                  "PTZ ${double.parse(widget.item.priceInPoints) / 100 * 10}",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 8,
                              ),
                            ), */
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: !difference.isNegative
                              ? /* AppColors.PRIMARY_COLOR */ !difference2
                                      .isNegative
                                  ? Colors.amber[600]
                                  : Color(0xFF64CE68)
                              : Colors.red,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            timeBtnSmall(
                              difference2: difference2,
                              context: context,
                              title: 'd',
                              active: true,
                              countdown: difference2.inSeconds > 0
                                  ? difference2.inDays.toString()
                                  : difference.inDays.toString(),
                              difference: difference,
                              taken: widget.item.itemQuantity == 0,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            timeBtnSmall(
                              difference2: difference2,
                              context: context,
                              title: 'h',
                              active: false,
                              countdown: difference2.inSeconds > 0
                                  ? difference2.inHours.remainder(24).toString()
                                  : difference.inHours.remainder(24).toString(),
                              difference: difference,
                              taken: widget.item.itemQuantity == 0,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            timeBtnSmall(
                              difference2: difference2,
                              context: context,
                              title: 'm',
                              active: false,
                              countdown: difference2.inSeconds > 0
                                  ? difference2.inMinutes
                                      .remainder(60)
                                      .toString()
                                  : difference.inMinutes
                                      .remainder(60)
                                      .toString(),
                              difference: difference,
                              taken: widget.item.itemQuantity == 0,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            timeBtnSmall(
                              difference2: difference2,
                              context: context,
                              title: 's',
                              active: false,
                              countdown: difference2.inSeconds > 0
                                  ? difference2.inSeconds
                                      .remainder(60)
                                      .toString()
                                  : difference.inSeconds
                                      .remainder(60)
                                      .toString(),
                              difference: difference,
                              taken: widget.item.itemQuantity == 0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
