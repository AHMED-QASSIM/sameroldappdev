import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../controllers/chats_controller.dart';
import '../controllers/user_controller.dart';
import '../models/chat_message_model.dart';
import '../models/chat_model.dart';

class ChatServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ChatServices() {
    _firestore.settings = Settings(persistenceEnabled: true);
  }

  Future<bool> readLastMessage(chatid) async {
    _firestore.collection("chats").doc(chatid).update({
      "isRead": true,
    });
    return true;
  }

  Future<bool> deleteMessage( docId) async {
    _firestore.collection("messages").doc(docId).delete();
    return true;
  }

  Future<bool> sendMessage(current_id,user_name,user_photo,user_id,message,type,user_phone,subscription,{String fileName = "لا يوجد اسم"})async{

    var doc = await _firestore.collection("messages").add({
     "user" : current_id,
     "reciver" : user_id,
     "type" : type,
     "message" : message,
     "fileName" : fileName,
     "date" :  DateTime.now().millisecondsSinceEpoch,
    });
   

    _firestore.collection("chats").where("user",isEqualTo: current_id).get().then((value) async{
     
    //  print(value.docs[0].data());

    if(value.size == 0){
        await _firestore.collection("chats").add({
           "sender" : current_id,
           "date" : DateTime.now(),
           "user_name" : user_name,
           "user_photo" : user_photo,
          "subscription" : subscription,
           "pinned" : false,
           "user_phone" : user_phone,
           "last_message" : type == "image" ? "صورة" : type == "voice" ?"رسالة صوتية" : type == "file" ? "ملف" : message,
           "user" : current_id
    }).then((value) {
    // Get.find<ChatsController>().getChats();
    });
    }else {
       await _firestore.collection("chats").doc(value.docs[0].id).update({
           "date" : DateTime.now(),
           "sender" : user_id,
           "isRead" : false,
           "last_message" : type == "image" ? "صورة" : type == "voice" ?"رسالة صوتية" : type == "file" ? "ملف"  :message,
    }).then((value){
    Get.find<ChatsController>().getChats();

    });
    }

    });


 try {

     var token = "";

     if(current_id == user_id){
      token = await FirebaseFirestore.instance.collection("users").where("isAdmin",isEqualTo: true).get().then((value) => value.docs[0].data()["token"]);
     }else {
     token = await FirebaseFirestore.instance.collection("users").where("phone",isEqualTo: user_phone).get().then((value) => value.docs[0].data()["token"]);
     }

    var response = await Dio().post('https://us-central1-smaer-gym-latest.cloudfunctions.net/sendToUserById',data: {
      "title" : Get.find<UserController>().user.value.name,
      "body" : type == "image" ? "ارسل اليك صورة" : type == "voice" ? "ارسل اليك رسالة صوتية" : type == "file" ? "ارسل اليك ملف" : message,
      "token" : [token],
      "type" : "chat",
    });
  } catch (e) {
    print(e);
  }
    
    return true;
  }

  Future<List<ChatModel>> getChats() async{
    var _doc = await _firestore
        .collection("chats")
      .where("subscription", isEqualTo: "gold")
        .orderBy("date", descending: true)
      .get();
      
    return _doc.docs.map((e) => ChatModel.fromDocumentSnapshot(documentSnapshot: e)).toList();

  }

    Future<List<ChatModel>> getOtherChats() async{
    var _doc = await _firestore
        .collection("chats")
        .where("subscription",isNotEqualTo: "gold")
         .orderBy("subscription")
        .orderBy("date", descending: true)
        .get();
      
    return _doc.docs.map((e) => ChatModel.fromDocumentSnapshot(documentSnapshot: e)).toList();

  }

//   Future<ChatModel> getChat(dynamic documentSnapshot) async {
//     List users = documentSnapshot.data()["users"];
//     var search = users.where((element) => element != Get.find<UserController>().user.value.id).toList();
    
//     if(search.length > 0){
// var doc = await _firestore.collection("users").doc(search[0]).get();
// if(doc.exists){
//       return ChatModel.fromDocumentSnapshot(documentSnapshot: documentSnapshot, userinfo: doc);

// }else {
//   return ChatModel(); 
// }
//     }else {
//       ChatModel chatModel = ChatModel();
//       return chatModel;
//     }
    
//   }


    Stream<List<ChatMessage>> getMessage(userid) {
     Stream <QuerySnapshot>  _doc = _firestore
        .collection("messages").where("user",isEqualTo: userid)
        .orderBy("date", descending: true)
        .snapshots();

    return _doc.map((event) => event.docs
        .map((e) => ChatMessage.fromDocumentSnapshot(documentSnapshot: e))
        .toList());
  }

  Future<bool> pinChat(chatid) async{
    _firestore.collection("chats").doc(chatid).update({
      "pinned" :true
    });
    return true;
  }

  Future<bool> unpinChat(chatid,date) async{
    _firestore.collection("chats").doc(chatid).update({
      "pinned" : false
    });
    return true;
  }

}
