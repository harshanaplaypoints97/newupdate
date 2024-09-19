import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:provider/provider.dart';

import '../../Provider/darkModd.dart';

class ResentWinnersCard extends StatefulWidget {
  final String profileImgUrl;
  final String userName;
  final String itemUrl;
  final String itemName;

  const ResentWinnersCard(
      this.profileImgUrl, this.userName, this.itemUrl, this.itemName,
      {Key key})
      : super(key: key);

  @override
  State<ResentWinnersCard> createState() => _ResentWinnersCardState();
}

class _ResentWinnersCardState extends State<ResentWinnersCard> {
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffdc88e),
                  Color(0xfffdac86),
                  Color(0xfffe907e)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100.0),
                bottomLeft: Radius.circular(100),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.09,
                    backgroundColor: Color(0xfffe7f2b),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: MediaQuery.of(context).size.width * 0.083,
                      backgroundImage: NetworkImage(
                        widget.profileImgUrl ??
                            "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Congratulations!",
                          style: TextStyle(
                              color: Color(0xffFF0000),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          widget.userName.length > 14
                              ? '${widget.userName.substring(0, 14)}...'
                              : widget.userName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          // margin: EdgeInsets.only(left: 12, right: 12),
                          decoration: BoxDecoration(
                            color: Color(0xffffd600),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.sp,
                                right: 8.sp,
                                top: 4.sp,
                                bottom: 4.sp),
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
                                      color: Color(0xffE24400),
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

                      // Container(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(20),
                      //     color: Color(0xffffd600),
                      //   ),
                      //   child: Text(
                      //     widget.itemName,
                      //     style: TextStyle(
                      //         color: Colors.red,
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w400),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),

            // Column(
            //   children: [
            //     SizedBox(
            //       width: size.width * 0.45,
            //       child: FittedBox(
            //         child: Text(
            //           "Congratulations!",
            //           style: TextStyle(
            //               fontFamily: "Arial",
            //               color: Colors.white,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 24.sp),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 2,
            // ),
            // Text(
            //   widget.userName.split(" ").elementAt(0),
            //   style: TextStyle(
            //       fontFamily: "Arial",
            //       color: Colors.white,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 16.sp),
            // ),
            // SizedBox(
            //   height: size.height * 0.01,
            // ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "You Won",
            //       style: TextStyle(
            //           fontSize: 12,
            //           fontFamily: "Arial",
            //           color: Colors.white,
            //           fontWeight: FontWeight.w700),
            //     ),
            //     SizedBox(
            //       height: 6.sp,
            //     ),

            //   ],
            // )
          ],
        ),
        Positioned(
          top: 15,
          right: 10,
          child: SizedBox(
            // height: size.width * 0.3,
            width: size.width * 0.25,
            child: CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: widget.itemUrl,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 5,
          child: Text(
            'Winner Circle',
            style: TextStyle(
                color: darkModeProvider.isDarkMode
                    ? Colors.white
                    : Color(
                        0xff000000,
                      ),
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class ResentWinnersCardS extends StatefulWidget {
  final String profileImgUrl;
  final String userName;
  final String itemUrl;
  final String itemName;

  const ResentWinnersCardS(
      this.profileImgUrl, this.userName, this.itemUrl, this.itemName,
      {Key key})
      : super(key: key);

  @override
  State<ResentWinnersCardS> createState() => _ResentWinnersCardSState();
}

class _ResentWinnersCardSState extends State<ResentWinnersCardS> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xfffdc88e),
                    Color(0xfffdac86),
                    Color(0xfffe907e)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),

            // Column(
            //   children: [
            //     SizedBox(
            //       width: size.width * 0.45,
            //       child: FittedBox(
            //         child: Text(
            //           "Congratulations!",
            //           style: TextStyle(
            //               fontFamily: "Arial",
            //               color: Colors.white,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 24.sp),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 2,
            // ),
            // Text(
            //   widget.userName.split(" ").elementAt(0),
            //   style: TextStyle(
            //       fontFamily: "Arial",
            //       color: Colors.white,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 16.sp),
            // ),
            // SizedBox(
            //   height: size.height * 0.01,
            // ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "You Won",
            //       style: TextStyle(
            //           fontSize: 12,
            //           fontFamily: "Arial",
            //           color: Colors.white,
            //           fontWeight: FontWeight.w700),
            //     ),
            //     SizedBox(
            //       height: 6.sp,
            //     ),

            //   ],
            // )
          ],
        ),
        Positioned(
          bottom: -5,
          right: 2,
          child: SizedBox(
              height: 160,
              width: 150,
              child: Image.network(
                widget.itemUrl,
                fit: BoxFit.fitHeight,
                height: 160,
                width: 150,
              )),
        ),
        Positioned(
          left: 20,
          top: 5,
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.09,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30,
              backgroundImage: NetworkImage(
                widget.profileImgUrl ??
                    "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Congratulations!",
                style: TextStyle(
                    color: Color(0xffFF5C00),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                widget.userName.length > 14
                    ? '${widget.userName.substring(0, 14)}...'
                    : widget.userName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'You Won',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                // margin: EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Color(0xffffd600),
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
                          widget.itemName.length > 14
                              ? '${widget.itemName.substring(0, 14)}...'
                              : widget.itemName ?? "Purchase Item",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Arial",
                            fontSize: 14.sp,
                            color: Color(0xffE24400),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        )
      ],
    );
  }
}

class NewWinnerCard extends StatelessWidget {
  final String profileImgUrl;
  final String userName;
  final String itemUrl;
  final String itemName;
  const NewWinnerCard({
    this.profileImgUrl,
    this.userName,
    this.itemUrl,
    this.itemName,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140, // Increase the height to accommodate the positioned image
      child: Stack(
        clipBehavior: Clip.none, // Allow overflow
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffdc88e),
                  Color(0xfffdac86),
                  Color(0xfffe907e)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      cacheManager: CustomCacheManager.instance,
                      imageUrl: profileImgUrl,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.19,
                      height: MediaQuery.of(context).size.width * 0.19,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Congratulations!",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        userName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xffffd600),
                        ),
                        child: Text(
                          itemName.length > 10
                              ? itemName.substring(0, 10)
                              : itemName,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom:
                -10, // Adjust this to position the image outside the container
            child: CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: itemUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.19,
              height: 80,
            ),
          ),
        ],
      ),
    );
  }
}
