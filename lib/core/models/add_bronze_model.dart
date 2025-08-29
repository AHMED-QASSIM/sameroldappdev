// To parse this JSON data, do
//
//     final addGoldMode = addGoldModeFromJson(jsonString);

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

AddBronzeModel addGoldModeFromJson(String str) => AddBronzeModel.fromJson(json.decode(str));

String addGoldModeToJson(AddBronzeModel data) => json.encode(data.toJson());

class AddBronzeModel {
    AddBronzeModel({
      required  this.since,
       required this.weight,
        this.images,
        required this.gymName,
        this.name,
        this.playerPhoto,
        required this.gymAddress,
        required this.hight
    });

    dynamic weight;
    List<String>? images;
    String since;
    String gymName;
    String gymAddress;
    String? name;
    String? playerPhoto;
    dynamic hight;


    factory AddBronzeModel.fromJson(Map<String, dynamic> json) => AddBronzeModel(
        weight: json["weight"],
        name : json["name"],
        playerPhoto : json["playerPhoto"],
        since: json["since"],
        images: List<String>.from(json["images"].map((x) => x)),
        gymName: json["gymName"],
        gymAddress: json["gymAddress"],
        hight: json["hight"],
    );

    Future<Map<String, dynamic>> toJson() async => {
        "weight": weight,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "status" : 2,
        "gymName" : gymName,
        "name" : name,
        "playerPhoto" : playerPhoto,
        "since" : since,
        "token" : await FirebaseMessaging.instance.getToken(),
        "gymAddress" : gymAddress,
        "hight" : hight,

    };
}
