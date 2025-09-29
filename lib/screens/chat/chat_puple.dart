import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smaergym/core/controllers/chats_controller.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../core/controllers/user_controller.dart';
import '../../core/models/chat_message_model.dart';
import '../../core/widgets/loader_image_widget.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;
  ChatBubble({required this.chatMessage});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  UserController userController = Get.find();
  ChatsController chatsController = Get.find();

  get Toast => null;

  void _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    int timestamp = widget.chatMessage.date ?? 0;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat('MMMM d,h:mm a', 'en').format(date);

    // Only change: assign fixed admin ID if current user ID is null
    String? currentUserId =
        userController.user.value.id ?? "swYiBLc2acMohYAh9Zp6xs6sDc52";

    return GestureDetector(onLongPress: () async {
      if (widget.chatMessage.type == "text") {
        await Clipboard.setData(
                ClipboardData(text: widget.chatMessage.message!))
            .then((value) {
          Toast.show("تم النسخ",
              duration: Toast.lengthShort, gravity: Toast.bottom);
        });

        if (widget.chatMessage.type == "image") {
          Get.bottomSheet(
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                  ),
                  height: 100,
                  child: CustomButton(
                    onPressed: () {
                      chatsController.deleteMessage(widget.chatMessage.id!);
                    },
                    text: "حذف الرسالة",
                    backgroundColor: const Color.fromARGB(255, 163, 48, 40),
                  ),
                ),
              ],
            ),
          );
        }
      }
      ;
      onDoubleTap:
      () {
        if (userController.user.value.admin == true) {
          Get.bottomSheet(
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                  ),
                  height: 100,
                  child: CustomButton(
                    onPressed: () {
                      chatsController.deleteMessage(widget.chatMessage.id!);
                    },
                    text: "حذف الرسالة",
                    backgroundColor: const Color.fromARGB(255, 163, 48, 40),
                  ),
                ),
              ],
            ),
          );
        }
      };
      onTap:
      () {
        if (widget.chatMessage.type == "image") {
          showImageViewer(
            context,
            NetworkImage(widget.chatMessage.message!),
            immersive: false,
            useSafeArea: true,
            swipeDismissible: true,
            onViewerDismissed: () {
              print("dismissed");
            },
          );
        }

        if (widget.chatMessage.type == "text" ||
            widget.chatMessage.type == "file") {
          if (Uri.tryParse(widget.chatMessage.message!)!.hasAbsolutePath) {
            _launchURL(widget.chatMessage.message!);
          }
        }
      };
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              formattedDate,
              style: TextStyle(fontSize: 10),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Align(
              alignment: (widget.chatMessage.reciver != currentUserId
                  ? Alignment.centerLeft
                  : Alignment.centerRight),
              child: widget.chatMessage.type == "voice"
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: VoiceMessageView(
                        circlesColor: Theme.of(context).primaryColor,
                        activeSliderColor: Theme.of(context).primaryColor,
                        counterTextStyle:
                            TextStyle(color: Colors.transparent, fontSize: 0),
                        controller: VoiceController(
                          maxDuration: const Duration(seconds: 20),
                          isFile: false,
                          onComplete: () {},
                          onPause: () {},
                          onPlaying: () {},
                          audioSrc: widget.chatMessage.message!,
                        ),
                      ),
                    )
                  : widget.chatMessage.type == "file"
                      ? GestureDetector(
                          onTap: () {
                            _launchURL(widget.chatMessage.message);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: widget.chatMessage.reciver == currentUserId
                                  ? Colors.grey.shade100
                                  : Theme.of(context).primaryColor,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.doc,
                                  color: widget.chatMessage.reciver !=
                                          currentUserId
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    widget.chatMessage.fileName
                                        .toString()
                                        .replaceAll("%20", " "),
                                    style: TextStyle(
                                        color: widget.chatMessage.sender !=
                                                currentUserId
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.download_circle,
                                  color: widget.chatMessage.reciver !=
                                          currentUserId
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: widget.chatMessage.type == "image"
                                ? Colors.grey.shade100
                                : (widget.chatMessage.reciver != currentUserId
                                    ? Theme.of(context).cardColor
                                    : Theme.of(context).primaryColor),
                          ),
                          padding: widget.chatMessage.type == "image"
                              ? EdgeInsets.zero
                              : EdgeInsets.all(16),
                          child: widget.chatMessage.type == "image"
                              ? LoadingImage(
                                  image: widget.chatMessage.message!,
                                  height: 300,
                                  width: MediaQuery.of(context).size.width / 2,
                                  radius: 10,
                                )
                              : Text(
                                  widget.chatMessage.message!,
                                  style: TextStyle(
                                    color: Uri.tryParse(
                                                widget.chatMessage.message!)!
                                            .hasAbsolutePath
                                        ? Color.fromARGB(255, 138, 185, 255)
                                        : widget.chatMessage.reciver !=
                                                currentUserId
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                                ),
                        ),
            ),
          ),
        ],
      );
    });
  }
}
