// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/controllers/user_controller.dart';
import 'package:smaergym/core/services/auth_services.dart';
import 'package:smaergym/screens/admin/chats/chats_screen.dart';
import 'package:smaergym/screens/auth/login_otp_screen.dart';
import 'package:smaergym/screens/auth/otb_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../screens/admin/dashboard/dashboard.dart';
import '../../screens/dashboard/dashboard.dart';

class AuthController extends GetxController {
  var loadlogin = false.obs;
  var loadregister = false.obs;
  var showError = false.obs;
  var errorMessage = "".obs;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var verifiId = "".obs;

  Future subscribeToNotification() async {
    await FirebaseMessaging.instance.subscribeToTopic("pushNotification");
  }

  Future subscribeToNPhoneNotification(String id) async {
    await FirebaseMessaging.instance.subscribeToTopic(id);
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  void register(
      {required String phone,
      required String name,
      required dynamic imageFile,
      required String imageType,
      required String code,
      required String email,
      required String password}) async {
    loadregister.value = true;

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email + "@gmail.com", password: password)
        .then((cred) async {
      if (cred.user != null) {
        await subscribeToNPhoneNotification(cred.user!.uid);

        AuthServices().checkRegister(phone).then((v) async {
          if (!v) {
            firebase_storage.Reference ref = firebase_storage
                .FirebaseStorage.instance
                .ref('userProfile')
                .child(DateTime.now().toString() + "." + imageType);

            await ref.putFile(imageFile).then((p0) {
              ref.getDownloadURL().then((value) async {
                AuthServices()
                    .createAccount(
                        image_url: value,
                        phone: phone,
                        name: name,
                        token: await getToken(),
                        email: email + "@gmail.com",
                        code: code,
                        password: password,
                        uid: cred.user!.uid)
                    .then((value) async {
                  var checkADmin = await AuthServices().checkAdmin(phone);

                  Get.offAll(checkADmin ? AdminDashboard() : Dashboard());

                  Get.find<UserController>().getUser();
                  loadregister.value = false;
                });
              });
            });
          } else {
            loadregister.value = false;
            FirebaseAuth.instance.signOut();
            Get.snackbar("خطأ", "يوجد حساب مسجل بالفعل",
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(20));
          }
        });
      }
    }).catchError((onError) {
      loadregister.value = false;
      Get.snackbar("خطأ", "يوجد حساب مسجل بالفعل",
          snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.all(20));
    });
  }

void login({required String email, required String password}) async {
  loadlogin.value = true;
  print("cred");
  print(email);
  print(password);

  // ✅ Special condition for employee
  if (email == "employee" && password == "samer@123") {
    loadlogin.value = false;
    Get.offAll(() => Chats()); // replace with your page widget
    return;
  }

  await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: email + "@gmail.com", password: password)
      .then((cred) async {
    print(cred);

    if (cred.user != null) {
      await subscribeToNPhoneNotification(cred.user!.uid);

      AuthServices()
          .checkRegister(await AuthServices().getUserPhone(cred.user!.uid))
          .then((v) async {
        if (!v) {
          loadlogin.value = false;
          FirebaseAuth.instance.signOut();
          Get.snackbar("خطأ", "قم بأنشاء حساب اولا",
              snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.all(20));
        } else {
          var checkADmin = await AuthServices()
              .checkAdmin(await AuthServices().getUserPhone(cred.user!.uid));

          Get.offAll(checkADmin ? AdminDashboard() : Dashboard());
          loadlogin.value = false;
          Get.find<UserController>().getUser();
        }
      });
    }
  }).catchError((onError) {
    print('thie erorrr');
    print(onError);
    loadlogin.value = false;
    print('thie erorrr');
  });
}


  void checkOtp({smsCode, imageFile, imageType, name}) async {
    loadregister.value = true;
    try {
      // PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //     verificationId: verifiId.value, smsCode: smsCode);

      // var cred = await _auth.signInWithCredential(credential);
      // if (cred.user != null) {
      //   await subscribeToNPhoneNotification(cred.user!.uid);

      //   AuthServices().checkRegister(cred.user!.phoneNumber!).then((v) async {
      //     if (!v) {
      //           firebase_storage.Reference ref = firebase_storage
      //               .FirebaseStorage.instance
      //               .ref('userProfile')
      //               .child(DateTime.now().toString() + "." + imageType);

      //           await ref.putFile(imageFile).then((p0) {
      //             ref.getDownloadURL().then((value) async{
      //               AuthServices()
      //                   .createAccount(
      //                       image_url: value,
      //                       phone: cred.user!.phoneNumber!,
      //                       name: name,
      //                        token : await getToken(),
      //                       uid: cred.user!.uid)
      //                   .then((value) async{
      //                     var checkADmin = await AuthServices().checkAdmin(cred.user!.phoneNumber!);

      //                 Get.offAll(checkADmin ? AdminDashboard() :  Dashboard());

      //                  Get.find<UserController>().getUser();
      //                 loadregister.value = false;
      //               });
      //             });
      //           });

      //     } else {
      //       loadregister.value = false;
      //       FirebaseAuth.instance.signOut();
      //       Get.snackbar("خطأ", "يوجد حساب مسجيل بالفعل",
      //           snackPosition: SnackPosition.BOTTOM,
      //           margin: EdgeInsets.all(20));
      //     }
      //   });
      // }
    } catch (e) {
      print(e);
      loadregister.value = false;
      Get.snackbar("خطأ", "رمز التحقق خطأ او انتهت صلاحيته",
          snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.all(20));
    }
  }

  void checkOtpLogin({smsCode}) async {
    loadlogin.value = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verifiId.value, smsCode: smsCode);

      var cred = await _auth.signInWithCredential(credential);
      if (cred.user != null) {
        await subscribeToNPhoneNotification(cred.user!.uid);

        AuthServices().checkRegister(cred.user!.phoneNumber!).then((v) async {
          if (!v) {
            loadlogin.value = false;
            FirebaseAuth.instance.signOut();
            Get.snackbar("خطأ", "قم بأنشاء حساب اولا",
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(20));
          } else {
            var checkADmin =
                await AuthServices().checkAdmin(cred.user!.phoneNumber!);

            Get.offAll(checkADmin ? AdminDashboard() : Dashboard());
            loadlogin.value = false;
            Get.find<UserController>().getUser();
          }
        });
      }
    } catch (e) {
      print(e);
      loadlogin.value = false;
      Get.snackbar("خطأ", "رمز التحقق خطأ او انتهت صلاحيته",
          snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.all(20));
    }
  }
}
