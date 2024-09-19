import 'dart:developer';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/Api/MarkertPlaceApi.dart';

import '../Api/ApiV2/api_V2.dart';
import '../models/NewModelsV2/store/resent_winners.dart';
import '../models/markertPlace/MarkertPlace_Profile_Item.dart';

class LeaderBoardController extends GetxController {
  var limit = 10;
  var offset = 0;
  var isLoading = true.obs;
  RxList<ResentWinners> WinnerItemList = <ResentWinners>[].obs;
  var tempWinnerItemList = List<ResentWinners>().obs;

  @override
  void onInit() {
    fetchWinners(offset, limit); // Fetch data when the controller initializes
    super.onInit();
  }

  void fetchWinners(int offset, int limit) async {
    try {
      isLoading(true);
      var markertItems = await ApiV2().getleaderBordWinnerList(offset, limit);
      if (markertItems != null && markertItems.body.orders.isNotEmpty) {
        Logger().e(offset);
        Logger().i(markertItems.body.orders.length);

        tempWinnerItemList.addAll([markertItems]);
        //WinnerItemList.clear();
        WinnerItemList.add(markertItems);

        WinnerItemList[0].body.orders.addAll(markertItems.body.orders);

        isLoading(false);
        WinnerItemList.refresh();
      }
    } catch (e) {
      // Handle errors
      print('Error occurred: $e');
    }
  }

  Future<void> loadMoreData(String Catergory) async {
    offset += 10;

    // Increase offset to load the next batch of data
    fetchWinners(offset, limit);
  }

  void clear() {
    WinnerItemList.clear();
    offset = 0;
  }
}
