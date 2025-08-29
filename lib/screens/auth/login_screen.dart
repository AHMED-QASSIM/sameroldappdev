import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/controllers/auth_controller.dart';
import 'package:smaergym/screens/auth/register_screen.dart';
import '../../../core/validator/validators/exact_length_rule.dart';
import '../../../core/validator/validators/is_required_rule.dart';
import '../../../core/validator/validators/max_length_rule.dart';
import '../../../core/validator/validators/regex_rule.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/validator/validators/min_length_rule.dart';
import '../../core/widgets/custom_button.dart';
import 'otb_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isPop;
  const LoginScreen({Key? key, this.isPop = false}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedCode = "+964";
  AuthController authController = Get.put(AuthController());
  final countryPicker = const FlCountryCodePicker();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height - 70,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    KeyboardVisibilityBuilder(builder: (context, keyboard) {
                      return keyboard
                          ? Container()
                          : Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 250.h,
                              child: Image.asset(
                                "assets/images/login.jpg",
                                width: MediaQuery.of(context).size.width,
                              ),
                            );
                    }),
                    KeyboardVisibilityBuilder(builder: (context, keyboard) {
                      return keyboard
                          ? SizedBox(
                              height: 60,
                            )
                          : Container();
                    }),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "اهلا بك!",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  "سجل الدخول الى حسابك",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                CustomTextFormField(
                                  controller: email,
                                  validators: [
                                    IsRequiredRule(),
                                    MinLengthRule(2),
                                    // username regex

                                    RegexRule(
                                        r"^[a-zA-Z0-9]+([_ -]?[a-zA-Z0-9])*$")
                                  ],
                                  hint: "ادخل اسم المستخدم",
                                  label: "اسم المستخدم",
                                ),
                                CustomTextFormField(
                                  controller: password,
                                  validators: [
                                    IsRequiredRule(),
                                    MinLengthRule(6),
                                  ],
                                  obscureText: true,
                                  hint: "ادخل كلمة المرور",
                                  label: "كلمة المرور",
                                  prefixIcon: Icon(
                                    CupertinoIcons.lock,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(
                          () => CustomButton(
                              loading: authController.loadlogin.value,
                              text: "تسجيل الدخول",
                              backgroundColor: Theme.of(context).primaryColor,
                              onPressed: () {
                                // Get.offAll(Dashboard());
                                if (_formKey.currentState!.validate()) {
                                  print("test");
                                  authController.login(
                                      email: email.text,
                                      password: password.text);
                                }
                              }),
                        )),
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 15),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(RegisterScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "انشاء",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              Text(
                                " حساب جديد",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    KeyboardVisibilityBuilder(builder: (context, keyboard) {
                      return !keyboard
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: SvgPicture.asset(
                                  "assets/svg/loginButtomShape.svg"))
                          : Container();
                    })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
