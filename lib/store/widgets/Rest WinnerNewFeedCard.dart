import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';

class RestWinnerNewFeed extends StatefulWidget {
  final String profileImgUrl;
  final String userName;
  final String itemUrl;
  final String itemName;

  const RestWinnerNewFeed(
      this.profileImgUrl, this.userName, this.itemUrl, this.itemName,
      {Key key})
      : super(key: key);

  @override
  State<RestWinnerNewFeed> createState() => _RestWinnerNewFeedState();
}

class _RestWinnerNewFeedState extends State<RestWinnerNewFeed> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              // height: size.height * 0.23,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xfffec5b2),
                    Color(0xfffeab9a),
                    Color(0xfffe8e7e)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.12,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: MediaQuery.of(context).size.width * 0.98,
                    backgroundImage: NetworkImage(
                      widget.profileImgUrl ??
                          "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Congratulations!",
                  style: TextStyle(
                      fontFamily: "Arial",
                      color: Color(0xffFF5C00),
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  widget.userName.toString().substring(0, 15),
                  style: TextStyle(
                      fontFamily: "Arial",
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "You Won",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Arial",
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 6.sp,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // margin: EdgeInsets.only(left: 12, right: 12),
                        decoration: BoxDecoration(
                          color: Color(0xffFFD600),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.sp, right: 8.sp, top: 4.sp, bottom: 4.sp),
                          child: Column(
                            children: [
                              Container(
                                width: size.width * 0.3,
                                child: Text(
                                  widget.itemName ?? "Purchase Item",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Arial",
                                    fontSize: 14.sp,
                                    color: Color(0xfffe7f2b),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
