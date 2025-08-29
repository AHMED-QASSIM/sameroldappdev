import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/controllers/user_courses_controller.dart';
import 'package:smaergym/core/models/user_model.dart';
import 'package:smaergym/core/services/auth_services.dart';

class UserController extends GetxController {

Rx<UserModel> user = Rx<UserModel>(UserModel());
RxBool loadPayment = false.obs;

  onInit() {
    FirebaseAuth.instance.authStateChanges().listen((u) {
if(FirebaseAuth.instance.currentUser != null){
  if(!FirebaseAuth.instance.currentUser!.isAnonymous){
      getUser();

       FirebaseMessaging.instance.getToken().then((value) async {
        print(value);
    FirebaseFirestore.instance.collection("users").where("phone",isEqualTo: await AuthServices().getUserPhone(u!.uid)).get().then((value2) async{
                    if(value2.docs.length > 0){
                      FirebaseFirestore.instance.collection("users").doc(value2.docs[0].id).update({"token" :value});
                    }

                    
                  });

                     FirebaseFirestore.instance.collection("players").where("phone",isEqualTo: await AuthServices().getUserPhone(u!.uid)).get().then((value3) async{
                      value3.docs.forEach((element) {
                        FirebaseFirestore.instance.collection("players").doc(element.id).update({"token" :value});
                      });
                    });
                    
    });

}
}
    });

}

  getUser() {
    AuthServices().getUser().then((value) {
      
      user.value = value;
Get.put(UserCoursesController());

    });
    AuthServices().checkUserCoursesNullToken();
  }


  subscribe() async{
    loadPayment.value = true;
    FirebaseFirestore.instance.collection("users").where("phone",isEqualTo: user.value.phone).get().then((value) {
      FirebaseFirestore.instance.collection("sections").where("title",isEqualTo: "محترف").get().then((value2) async {
       

     await FirebaseFirestore.instance.collection("players").add({
          "phone" : user.value.phone,
          "status" : 1,
          "subscription": "gold",
          "token" : value.docs[0]["token"],
          "postcode" : "+964",
          "name" : value.docs[0]["full_name"],
          "date" : DateTime.now().toString(),
          "section" : value2.docs[0].id,
          "courses" : 1,
          "payType" : "credit",
      });


      // refresh user courses in getx controller
      Get.find<UserCoursesController>().getCurrentCourse();
      loadPayment.value = false;

      });

    });
    loadPayment.value = false;
  }

}