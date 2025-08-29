import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smaergym/core/models/offer_model.dart';
import 'package:smaergym/core/models/sections_model.dart';

class SectionServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SectionServices() {
    _firestore.settings = Settings(persistenceEnabled: true);
  }

  Future<List<SectionModel>> getSections() async {
    var _doc = await _firestore.collection("sections").get();
    return _doc.docs.map((e) => SectionModel.fromDocumentSnapshot(documentSnapshot: e)).toList();
  }


  Future<List<OfferModel>> getOffers() async {
    var _doc = await _firestore.collection("offers").get();
    return _doc.docs.map((e) => OfferModel.fromDocumentSnapshot(documentSnapshot: e)).toList();
  }



}
