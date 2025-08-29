// To parse this JSON data, do
//
//     final addCourseModel = addCourseModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

AddCourseModel addCourseModelFromJson(String str) => AddCourseModel.fromJson(json.decode(str));

String addCourseModelToJson(AddCourseModel data) => json.encode(data.toJson());



class AddCourseModel {
    AddCourseModel({
        this.title,
        this.section,
        this.date,
        this.days,
    });

    String? title;
    String? section;
    DateTime? date;
    List<Day>? days;

    factory AddCourseModel.fromJson(Map<String, dynamic> json) => AddCourseModel(
        title: json["title"],
        section: json["section"],
        date: json["date"],
        days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "section": section,
        "date": date,
        "days": List<dynamic>.from(days!.map((x) => x.toJson())),
    };
}

class Day {
    Day({
        this.exercises,
        this.image,
        this.name
    });

    List<Exercise>? exercises;
    String? name;
    String? image;

    factory Day.fromJson(Map<String, dynamic> json) => Day(
        exercises: List<Exercise>.from(json["exercises"].map((x) => Exercise.fromJson(x))),
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "exercises": List<dynamic>.from(exercises!.map((x) => x.toJson())),
        "name": name,
        "image": image,
    };
}

class Exercise {
    Exercise({
        this.id,
        this.sets,
        this.exerciseSuper,
        this.name
    });

    String? id;
    String? sets;
    List<Super>? exerciseSuper;
    String? name;

    factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["id"],
        sets: json["sets"],
        name : json["name"],
        exerciseSuper:List<Super>.from(json["exerciseSuper"].map((x) => Super.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sets": sets,
        "name" : name,
        "exerciseSuper":List<dynamic>.from(exerciseSuper!.map((x) => x.toJson())),
    };
}

class Super {
    Super({
        this.id,
        this.sets,
        this.name
    });

    String? id;
    String? sets;
    String? name;

    factory Super.fromJson(Map<String, dynamic> json) => Super(
        id: json["id"],
        sets: json["sets"],
        name : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sets": sets,
        "name" : name
    };

    
}

