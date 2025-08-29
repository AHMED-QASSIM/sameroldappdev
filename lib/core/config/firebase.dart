import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/controllers/chats_controller.dart';

class Firebase extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  if (message.notification != null) {
    Get.snackbar(message.notification?.title ?? "رسالة جديدة", message.notification?.body ?? "",snackPosition: SnackPosition.TOP,margin: EdgeInsets.all(20));
    Get.find<ChatsController>().getChats();
  }
});

    super.onInit();
  }
}
