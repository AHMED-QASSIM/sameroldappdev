// To parse this JSON data, do
//
//     final addGoldMode = addGoldModeFromJson(jsonString);

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

AddSilverModel addGoldModeFromJson(String str) => AddSilverModel.fromJson(json.decode(str));

String addGoldModeToJson(AddSilverModel data) => json.encode(data.toJson());

class AddSilverModel {
    AddSilverModel({
      required  this.goal,
       required this.injurse,
       required this.hight,
       required this.weight,
       required this.notes,
        this.images,
        required this.gymName,
        this.name,
        this.playerPhoto,
        required this.gymAddress
    });

    String goal;
    String injurse;
    dynamic hight;
    dynamic weight;
    String notes;
    List<String>? images;
    String gymName;
    String? name;
    String? playerPhoto;
    String? gymAddress;

    factory AddSilverModel.fromJson(Map<String, dynamic> json) => AddSilverModel(
        goal: json["goal"],
        injurse: json["injurse"],
        hight: json["hight"],
        weight: json["weight"],
        notes: json["notes"],
        name : json["name"],
        playerPhoto : json["playerPhoto"],
        images: List<String>.from(json["images"].map((x) => x)),
        gymName: json["gymName"],
        gymAddress: json["gymAddress"],
    );

    Future<Map<String, dynamic>> toJson() async => {
        "goal": goal,
        "injurse": injurse,
        "hight": hight,
        "weight": weight,
        "notes": notes,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "status" : 2,
        "gymName" : gymName,
        "name" : name,
        "playerPhoto" : playerPhoto,
        "token" : await FirebaseMessaging.instance.getToken(),
        "gymAddress" : gymAddress,
    };
}
