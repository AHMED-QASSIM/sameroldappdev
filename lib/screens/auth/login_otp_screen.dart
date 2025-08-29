import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:smaergym/core/controllers/auth_controller.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/screens/dashboard/dashboard.dart';

class LoginOtpScreen extends StatefulWidget {


  
  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<LoginOtpScreen> {
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController authController = Get.find();

  final defaultPinTheme = PinTheme(
    width: 50.w,
    height: 50.w,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.h,
          elevation: 0,
          centerTitle: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
          title: Text(
            " رمز التحقق",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        

         KeyboardVisibilityBuilder(builder: (context, keyboard) {
                      return !keyboard
                          ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/json/otp.json"),
                      ],
                    ): Container();
         },
         ),
        
                    Row(children: [
                      Text(
                      "تم ارسال رمز التحقق الى هاتفك",
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                    SizedBox(width: 5,),
                    Icon(CupertinoIcons.phone,color: Theme.of(context).cardColor,)
                    ],),
                    SizedBox(
                      height: 15,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        validator: (s) {},
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onCompleted: (pin) {
                          authController.checkOtpLogin(
                              smsCode: pin);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
        
                    Obx(()=> CustomButton(
                      loading: authController.loadlogin.value,
                      onPressed: (){
                      
                    },backgroundColor: Theme.of(context).primaryColor,text: "ارسال",)
                    )
                  ],
                )),
          ),
        ));
  }
}
