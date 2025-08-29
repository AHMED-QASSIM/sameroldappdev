// To parse this JSON data, do
//
//     final addGoldMode = addGoldModeFromJson(jsonString);

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

AddGoldMode addGoldModeFromJson(String str) => AddGoldMode.fromJson(json.decode(str));

String addGoldModeToJson(AddGoldMode data) => json.encode(data.toJson());

class AddGoldMode {
    AddGoldMode({
      required  this.goal,
       required this.unWantedFood,
       required this.injurse,
       required this.age,
       required this.hight,
       required this.weight,
       required this.work,
       required this.sleep,
       required this.useHrmon,
       required this.notes,
        this.images,
        this.tests,
        required this.gymName,
        this.name,
        this.playerPhoto,
        required this.gymAddress
    });

    String goal;
    String unWantedFood;
    String injurse;
    dynamic age;
    dynamic hight;
    dynamic weight;
    dynamic work;
    dynamic sleep;
    String useHrmon;
    String notes;
    List<String>? images;
    List<String>? tests;
    String gymName;
    String? name;
    String? playerPhoto;
    String? gymAddress;

    factory AddGoldMode.fromJson(Map<String, dynamic> json) => AddGoldMode(
        goal: json["goal"],
        unWantedFood: json["unWantedFood"],
        injurse: json["injurse"],
        age: json["age"],
        hight: json["hight"],
        weight: json["weight"],
        work: json["work"],
        sleep: json["sleep"],
        useHrmon: json["useHrmon"],
        notes: json["notes"],
        name : json["name"],
        playerPhoto : json["playerPhoto"],
        images: List<String>.from(json["images"].map((x) => x)),
        tests: List<String>.from(json["tests"].map((x) => x)),
        gymName: json["gymName"],
        gymAddress: json["gymAddress"],
    );

    Future<Map<String, dynamic>> toJson() async => {
        "goal": goal,
        "unWantedFood": unWantedFood,
        "injurse": injurse,
        "age": age,
        "hight": hight,
        "weight": weight,
        "work": work,
        "sleep": sleep,
        "useHrmon": useHrmon,
        "notes": notes,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "tests": List<dynamic>.from(tests!.map((x) => x)),
        "status" : 2,
        "gymName" : gymName,
        "name" : name,
        "playerPhoto" : playerPhoto,
        "token" : await FirebaseMessaging.instance.getToken(),
        "gymAddress" : gymAddress,

    };
}
