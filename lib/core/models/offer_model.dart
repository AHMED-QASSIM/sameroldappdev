import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  String? url_image;

  String? docid;

  OfferModel({this.url_image,this.docid});

  OfferModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    dynamic d = documentSnapshot.data();
    url_image = d["url_image"];
    docid = documentSnapshot.id;
  }
}
