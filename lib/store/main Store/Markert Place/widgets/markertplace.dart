import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Provider/darkModd.dart';

class MarkertplaceItem extends StatefulWidget {
  final String ItemName;
  final String ItemPrice;
  final String ItemDescriptionList;
  final String ItemImage;

  const MarkertplaceItem({
    @required this.ItemName,
    @required this.ItemPrice,
    @required this.ItemDescriptionList,
    @required this.ItemImage,
    Key key,
  }) : super(key: key);

  @override
  State<MarkertplaceItem> createState() => _MarkertplaceItemState();
}

class _MarkertplaceItemState extends State<MarkertplaceItem> {
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: darkModeProvider.isDarkMode
            ? Color.fromARGB(255, 44, 44, 44)
            : Colors.white,
      ),
      width: MediaQuery.of(context).size.width / 2.22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            child: CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.width / 2.40,
              cacheManager: CustomCacheManager.instance,
              imageUrl: widget.ItemImage ?? "",
              errorWidget: (context, url, error) {
                // Retry after a delay
                Future.delayed(Duration(seconds: 5), () {
                  setState(() {
                    // Update the widget or retry the image loading logic
                  });
                });
                return Shimmer(
                  child: Container(
                    height: MediaQuery.of(context).size.width /
                        6, // Adjust the height based on your design
                    width: (MediaQuery.of(context).size.width - 40) / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      color: Color(0xffC4C4C4).withOpacity(0.3),
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[300],
                      Colors.grey[200],
                      Colors.grey[300]
                    ],
                    begin: Alignment(-1, -1),
                    end: Alignment(1, 1),
                    stops: [0, 0.5, 1],
                  ),
                );
              },
              placeholder: (context, url) => Shimmer(
                child: Container(
                  height: MediaQuery.of(context).size.width /
                      6, // Adjust the height based on your design
                  width: (MediaQuery.of(context).size.width - 40) / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    color: Color(0xffC4C4C4).withOpacity(0.3),
                  ),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[300],
                    Colors.grey[200],
                    Colors.grey[300]
                  ],
                  begin: Alignment(-1, -1),
                  end: Alignment(1, 1),
                  stops: [0, 0.5, 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5),
            child: Text(
              widget.ItemName.length > 20
                  ? widget.ItemName.substring(0, 20)
                  : widget.ItemName,
              style: TextStyle(
                  color: darkModeProvider.isDarkMode
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16),
              maxLines: 1,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 10),
            child: Text(
              "Rs. " +
                      NumberFormat('###,000')
                          .format(int.parse(widget.ItemPrice)) ??
                  "",
              style: TextStyle(
                  color: Color(0xffE15C34),
                  fontWeight: FontWeight.w400,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
