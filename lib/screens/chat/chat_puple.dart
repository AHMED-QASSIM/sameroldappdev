import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smaergym/core/controllers/chats_controller.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../core/controllers/user_controller.dart';
import '../../core/models/chat_message_model.dart';
import '../../core/widgets/loader_image_widget.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessage chatMessage;
  const ChatBubble({super.key, required this.chatMessage});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final UserController userController = Get.find();
  final ChatsController chatsController = Get.find();

  void _launchURL(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('❌ Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = widget.chatMessage.date ?? 0;
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formattedDate = DateFormat('MMMM d, h:mm a', 'en').format(date);

    final currentUserId =
        FirebaseAuth.instance.currentUser?.uid ?? userController.user.value.id;

    final isCurrentUser = widget.chatMessage.reciver == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(formattedDate, style: const TextStyle(fontSize: 10)),
          GestureDetector(
            onTap: () {
              if (widget.chatMessage.type == "image") {
                showImageViewer(
                  context,
                  NetworkImage(widget.chatMessage.message!),
                  immersive: false,
                  useSafeArea: true,
                  swipeDismissible: true,
                  onViewerDismissed: () => print("dismissed"),
                );
              } else if (widget.chatMessage.type == "text" ||
                  widget.chatMessage.type == "file") {
                _launchURL(widget.chatMessage.message!);
              }
            },
            onLongPress: () async {
              if (widget.chatMessage.type == "text") {
                await Clipboard.setData(
                  ClipboardData(text: widget.chatMessage.message!),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم النسخ")),
                );
              }

              if (widget.chatMessage.type == "image" ||
                  userController.user.value.admin == true) {
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    height: 100,
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () =>
                          chatsController.deleteMessage(widget.chatMessage.id!),
                      text: "حذف الرسالة",
                      backgroundColor: const Color.fromARGB(255, 163, 48, 40),
                    ),
                  ),
                );
              }
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.86,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: widget.chatMessage.type == "image"
                      ? Colors.grey.shade100
                      : (isCurrentUser
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor),
                ),
                padding: widget.chatMessage.type == "image"
                    ? EdgeInsets.zero
                    : const EdgeInsets.all(12),
                child: _buildMessageContent(context, isCurrentUser),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isCurrentUser) {
    final msg = widget.chatMessage;

    switch (msg.type) {
      case "voice":
        return FutureBuilder<String>(
          future: _getLocalVoicePath(msg.message!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }

            final localPath = snapshot.data!;

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: VoiceMessageView(
                circlesColor: Theme.of(context).primaryColor,
                activeSliderColor: Theme.of(context).primaryColor,
                counterTextStyle:
                    const TextStyle(color: Colors.transparent, fontSize: 0),
                controller: VoiceController(
                  isFile: true, // ✅ FIXED
                  audioSrc: localPath, // ✅ LOCAL FILE PATH
                  maxDuration: const Duration(minutes: 3),
                  onComplete: () {},
                  onPause: () {},
                  onPlaying: () {},
                ),
              ),
            );
          },
        );

      case "file":
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.doc),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                msg.fileName?.replaceAll("%20", " ") ?? "File",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Icon(CupertinoIcons.download_circle),
          ],
        );

      case "image":
        return SafeNetworkImage(
          msg.message!,
          width: MediaQuery.of(context).size.width / 2,
          height: 250,
          radius: 10,
          fit: BoxFit.cover,
        );

      default:
        return Text(
          msg.message!,
          style: TextStyle(
            color: Uri.tryParse(msg.message!)?.hasAbsolutePath ?? false
                ? const Color.fromARGB(255, 138, 185, 255)
                : (isCurrentUser ? Colors.white : Colors.black),
          ),
        );
    }
  }

  Widget SafeNetworkImage(String? url,
      {double? width,
      double? height,
      double radius = 0,
      BoxFit fit = BoxFit.cover}) {
    if (url == null || url.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
              child: Container(
                  color: Colors.white,
                  width: width,
                  height: height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )));
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
          );
        },
      ),
    );
  }

  Future<String> _getLocalVoicePath(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath =
          "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a";
      final file = File(filePath);

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file.path; // return local path
      } else {
        print("❌ Failed to download voice file");
        return url; // fallback
      }
    } catch (e) {
      print("❌ Voice download error: $e");
      return url;
    }
  }
}
