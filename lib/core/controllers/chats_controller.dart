import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:smaergym/core/controllers/user_controller.dart';

import '../models/chat_message_model.dart';
import '../models/chat_model.dart';
import '../services/chat_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatsController extends GetxController {
var loadchats = false.obs;
var loadfile = false.obs;
var loadMessage = false.obs;
RxList<ChatModel> chats = RxList<ChatModel>();
RxList<ChatModel> otherChat = RxList<ChatModel>();

StreamSubscription<List<ChatMessage>>? _currentSubscription;
RxList<ChatMessage> messages = RxList<ChatMessage>();


  getChats({loaddata = true}) async{
    if(loaddata){
      loadchats.value = true;
    }
    var response = await ChatServices().getChats();
    chats.clear();

    if(response.isNotEmpty){
      // response.sort((a, b) => b.pinned == true ? 1 : 0);
      // sort by pinned to show pinned chats first

 if(response.any((element) => element.pinned == true)){
        response.forEach((element) {
          if(element.id != null && element.pinned){
        chats.add(element);
          }
        });
      }
      
      response.forEach((element) {
        if(element.id != null && !element.pinned){
      chats.add(element);

        }
      });

     

      loadchats.value = false;
    }else {
      loadchats.value = false;
    }
  }


   getOtherChats({loaddata = true}) async{
    if(loaddata){
      loadchats.value = true;
    }
    var response = await ChatServices().getOtherChats();

    otherChat.clear();

    if(response.isNotEmpty){
      // response.sort((a, b) => b.pinned == true ? 1 : 0);
      // sort by pinned to show pinned chats first

 if(response.any((element) => element.pinned == true)){
        response.forEach((element) {
          if(element.id != null && element.pinned){
        otherChat.add(element);
          }
        });
      }
      
      response.forEach((element) {
        if(element.id != null && !element.pinned){
      otherChat.add(element);

        }
      });

     

      loadchats.value = false;
    }else {
      loadchats.value = false;
    }
  }

Future<bool> deleteMessage(docId) async {
    var response = await ChatServices().deleteMessage(docId);
    if(response){
      getChats();
      getOtherChats();
      Get.back();
      return true;
    }else {
      return false;
    }
  }

  Future<bool> pinChat(chatid) async {
    var response = await ChatServices().pinChat(chatid);
    if(response){
      getChats();
      getOtherChats();
      Get.back();
      return true;
    }else {
      return false;
    }
  }

  Future<bool> unPinChat(chatid,date) async {
    var response = await ChatServices().unpinChat(chatid,date);
    if(response){
      getChats();
      getOtherChats();
      Get.back();
      return true;
    }else {
      return false;
    }
  }

   Future<void> getMessages(String? userId) async {
    // Deactivate previous subscriptions for inactive chats
      _currentSubscription?.cancel(); // Cancel the current subscription if it exists

    // Activate subscription for the current chat
    _currentSubscription = ChatServices().getMessage(userId).listen((msgs) {
      messages.assignAll(msgs);
      // For example, you can update your messages list here
    });
  }

  Future<bool> readMeesage(chatId) async{
    var response = await ChatServices().readLastMessage(chatId);
    getChats();
    getOtherChats();
    return response;
  }

  addChat(user_id,user_name,user_image,user_phone,type,subscription,{message,imageType,fileName}) async{
    if(type == "text"){
 ChatServices().sendMessage(user_id,user_name,user_image, Get.find<UserController>().user.value.id, message,"text",user_phone,subscription).then((value){
       
     });
    }

    if(type == "image"){
      loadfile.value = true;
      
            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('chatsImage')
          .child(DateTime.now().toString() + "." + imageType);

      await ref.putFile(message).then((p0) async {
        ref.getDownloadURL().then((value) async {
      loadfile.value = false;

       ChatServices().sendMessage(user_id,user_name,user_image, Get.find<UserController>().user.value.id, value,"image",user_phone,subscription).then((value){
       
     });

        });

      });
    }

     if(type == "file"){
      loadfile.value = true;
      
            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('chatFiles')
          .child(fileName.toString().replaceAll(" ", "-"));

      await ref.putFile(message).then((p0) async {
        ref.getDownloadURL().then((value) async {
      loadfile.value = false;

       ChatServices().sendMessage(user_id,user_name,user_image, Get.find<UserController>().user.value.id, value,"file",user_phone,subscription,fileName: fileName).then((value){
       
     });

        });

      });
    }

    if(type == "voice"){

 String filePath = message.replaceFirst('file://', '');
File file = File(filePath);

if (!file.existsSync()) {
  print('Error: The file does not exist at path: $filePath');
  return;
}

      try {
        loadfile.value = true;
          firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('voices')
          .child(DateTime.now().toString() + "." + "m4a");

print(file.path);
  await ref.putFile(file).then((p0) async {
        ref.getDownloadURL().then((value) async {
      loadfile.value = false;

       ChatServices().sendMessage(user_id,user_name,user_image, Get.find<UserController>().user.value.id, value,"voice",user_phone,subscription).then((value){
       
     });

        });

      });
          
      }catch(e){
              loadfile.value = false;
        print(e);
      }
    }

Future.delayed(Duration(seconds: 2),(){
    getOtherChats();
});
    

  }

   @override
  void onClose() {
    // Cancel all subscriptions when the chat feature is no longer used
    messages.clear();
   _currentSubscription?.cancel();
    super.onClose();
  }

}