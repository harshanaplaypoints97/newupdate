import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/Chat/Controller/ConversationController.dart';
import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
import 'package:play_pointz/screens/Chat/Screens/components/Chat_Header.dart';
import 'package:play_pointz/screens/Chat/Screens/components/Coversation_Card.dart';
import 'package:play_pointz/screens/Chat/Screens/components/FreindsOfTheChat.dart';
import 'package:play_pointz/screens/Chat/Users/components/User_Card.dart';
import 'package:play_pointz/screens/Chat/model/conversationmodel.dart';
import 'package:play_pointz/screens/home/components/notification_loading_shimmer.dart';
// import 'package:play_pointz/screens/profile/profile_new.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:provider/provider.dart';

import '../../../Api/handle_api.dart';
import '../../../Provider/darkModd.dart';
import '../../../constants/default_router.dart';
import '../../../controllers/friends_controller.dart';
import '../../feed/CustomCacheManager.dart';

class MainChatScreen extends StatefulWidget {
  @override
  _MainChatScreenState createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  int count = 0;
  final List<CovercationModel> _list = [];
  List<CovercationModel> _foundlist = [];
  List<CovercationModel> _newlist = [];
  bool myData = false;
  var profileData;

  @override
  void initState() {
    super.initState();
    getPlayerDetails();
    Get.put(FriendsController());
    _newlist = _list;
  }

  getPlayerDetails() async {
    await HandleApi().getPlayerProfileDetails();
    profileData = await getPlayerPref(key: "playerProfileDetails");
    setState(() {
      myData = true;
    });
  }

  void _runfilter(String keyword, int index) {
    if (_newlist.isEmpty) {
      _newlist = _list;
    } else {
      _newlist = _list
          .where((conversation) => conversation.UserProfileName.toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    }

    if (_newlist.isNotEmpty && index >= 0 && index < _newlist.length) {
      setState(() {
        // Just accessing the specific model based on the index
        CovercationModel specificModel = _newlist[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return SafeArea(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: Column(
            children: [
              _buildHeader(context, darkModeProvider),
              Expanded(
                child: Container(
                  color: darkModeProvider.isDarkMode
                      ? AppColors.darkmood
                      : Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRecentHeader(context, darkModeProvider),
                        Expanded(
                          child: _buildConversationList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndDocked,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DarkModeProvider darkModeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: darkModeProvider.isDarkMode
            ? AppColors.darkmood.withOpacity(0.8)
            : Color(0xFFEDEDED),
      ),
      height: MediaQuery.of(context).size.width / 2.5,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chats",
                  style: TextStyle(
                    color: darkModeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Container(
              height: 45,
              margin: EdgeInsets.only(top: 10),
              child: TextFormField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF828282),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          Color.fromARGB(255, 178, 178, 249).withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          Color.fromARGB(255, 178, 178, 249).withOpacity(0.5),
                      width: 0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.name,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                enableSuggestions: false,
                onChanged: (value) {
                  _runfilter(value, 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentHeader(
      BuildContext context, DarkModeProvider darkModeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        "Recents",
        style: TextStyle(
          color:
              darkModeProvider.isDarkMode ? AppColors.WHITE : Color(0xff536471),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildConversationList() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: ChatController()
              .getconversation(userController.currentUser.value.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return NotificationLoadingShimmer();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
              return Text('No conversations available.');
            }

            // Update _list and _newlist once
            if (_list.isEmpty) {
              _list.addAll(snapshot.data.docs
                  .map((doc) => CovercationModel.fromJson(
                      doc.data() as Map<String, dynamic>))
                  .toList());
              _newlist = List.from(_list); // Initialize _newlist with _list
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                return CoversationCard(
                  UpdateSte: userController.currentUser.value.id ==
                          _newlist[index].userlist[0]
                      ? "reciver"
                      : "sender",
                  id: userController.currentUser.value.id,
                  profileData: profileData,
                  ProfileName: _newlist[index].UserProfileName,
                  profileImage: _newlist[index].UserProfileImage,
                  Time: _newlist[index].lastMessageTime,
                  model: _newlist[index],
                  modelid: _newlist[index].id,
                  index: index,
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 0),
              itemCount: _newlist.length,
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FloatingActionButton(
        backgroundColor: Color(0xffFF721C),
        onPressed: () {
          Get.to(FreindsAddScreen());
        },
        child: Icon(
          Icons.chat,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
