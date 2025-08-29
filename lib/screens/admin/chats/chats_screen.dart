import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart' as intl;
import 'package:since_date/since_date.dart';
import 'package:smaergym/screens/auth/login_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/controllers/chats_controller.dart';
import '../../../core/controllers/user_controller.dart';
import '../../../core/models/chat_model.dart';
import '../../../core/widgets/loader_image_widget.dart';
import '../../../core/widgets/loading_widget_user.dart';
import '../../../core/widgets/no_data_widget.dart';
import '../../chat/chat_screen.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  ChatsController chatsController = Get.put(ChatsController());
  UserController user = Get.find();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    chatsController.getChats().then((value) {
      _refreshController.refreshCompleted();
    });

    chatsController.getOtherChats().then((value) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    chatsController.getChats();
    chatsController.getOtherChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      onRefresh: _onRefresh,
      controller: _refreshController,
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: "الاشتراك الذهبي",
                  ),
                  Tab(
                    text: "الاشتراكات الاخرى",
                  ),
                ],
              ),
              toolbarHeight: 60.h,
              centerTitle: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "المحادثات",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 250,
                  ),
                  IconButton(
                    icon: Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.rotationY(3.1416), // flips horizontally
                      child: Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                    onPressed: () async {
                      FirebaseAuth.instance.signOut().then((value) {
                        Get.offAll(LoginScreen());
                      });
                    },
                  )
                ],
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 20),
              child: TabBarView(
                children: [
                  Obx(
                    () => chatsController.loadchats.value
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: LoadingWidgetProfile(),
                              );
                            },
                          )
                        : chatsController.chats.length == 0
                            ? Center(
                                child: NoData(
                                  title: "لا يوجد محادثات",
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: chatsController.chats.length,
                                itemBuilder: (context, pos) {
                                  return chatsController
                                              .chats[pos].user_image !=
                                          null
                                      ? chat(chatsController.chats[pos])
                                      : Container();
                                },
                              ),
                  ),

                  // other

                  Obx(
                    () => chatsController.loadchats.value
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: LoadingWidgetProfile(),
                              );
                            },
                          )
                        : chatsController.otherChat.length == 0
                            ? Center(
                                child: NoData(
                                  title: "لا يوجد محادثات",
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: chatsController.otherChat.length,
                                itemBuilder: (context, pos) {
                                  return chatsController
                                              .otherChat[pos].user_image !=
                                          null
                                      ? chat(chatsController.otherChat[pos])
                                      : Container();
                                },
                              ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget chat(ChatModel chatModel) {
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-d');
    final intl.DateFormat time = intl.DateFormat('H:m');

    return InkWell(
      onTap: () {
         print("chatModel");
        print(chatModel.last_message);
        Get.to(() => ChatPage(chatModel: chatModel));
      },
      onLongPress: () {
        Get.bottomSheet(Container(
          height: 70.sp,
          decoration: BoxDecoration(color: Get.theme.scaffoldBackgroundColor),
          child: !chatModel.pinned
              ? InkWell(
                  onTap: () {
                    chatsController.pinChat(chatModel.id!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/pin.svg",
                          width: 20.sp,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "تثبيت",
                          style: TextStyle(fontSize: 16.sp),
                        )
                      ],
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    chatsController.unPinChat(chatModel.id!, chatModel.date);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/unpin.svg",
                          width: 20.sp,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "الغاء التثبيت",
                          style: TextStyle(fontSize: 16.sp),
                        )
                      ],
                    ),
                  ),
                ),
        ));
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LoadingImage(
                    image: chatModel.user_image ??
                        "https://www.noage-official.com/wp-content/uploads/2020/06/placeholder.png",
                    radius: 100,
                    width: 50.w,
                    height: 50.w,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chatModel.user_name!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
                          height: 20,
                          child: Text(
                            chatModel.last_message!,
                            style: TextStyle(
                                color: chatModel.sender != user.user.value.id
                                    ? Colors.black
                                    : Colors.grey,
                                height: 1.4,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13),
                          )),
                    ],
                  )),

                  if (chatModel.pinned)
                    SvgPicture.asset(
                      "assets/svg/pin.svg",
                      width: 14.sp,
                      color: Colors.grey,
                    ),

                  if (chatModel.sender != user.user.value.id &&
                      !chatModel.isRead!)
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue),
                    ),

                  // ...

                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(timeago.format(
                        chatModel.date?.toDate() ?? DateTime.now(),
                        locale: 'en_short')),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 0.1,
                thickness: 0.3,
              ),
              SizedBox(
                height: 5,
              ),
            ],
          )),
    );
  }
}
