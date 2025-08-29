// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:smaergym/core/config/firebase.dart';
import 'package:smaergym/core/controllers/offers_controller.dart';
import 'package:smaergym/core/controllers/user_controller.dart';
import 'package:smaergym/core/controllers/user_courses_controller.dart';
import 'package:smaergym/core/models/card_model.dart';
import 'package:smaergym/core/widgets/loader_image_widget.dart';
import 'package:smaergym/screens/auth/login_screen.dart';
import 'package:smaergym/screens/home/components/custom_pay_button.dart';
import 'package:smaergym/screens/notifications/notifications_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OfferController offerController = Get.put(OfferController());
  UserController userController = Get.find();
  Firebase firebaseController = Get.put(Firebase());
  bool isSubscribed = false;

  @override
  void initState() {
    // TODO: implement initState

    //checkSubscribe();
    super.initState();
  }

  // checkSubscribe() async {
  //   try {
  //     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  //     if (customerInfo.entitlements.all["gold"]?.isActive == true) {
  //       // Grant user "pro" access
  //       print("okay");
  //       setState(() {
  //         isSubscribed = true;
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسية", style: TextStyle(fontSize: 18)),
        actions: [
          Obx(() => userController.user.value.id != null
              ? IconButton(
                  onPressed: () {
                    Get.to(NotificationPage());
                  },
                  icon: const Icon(CupertinoIcons.bell))
              : GestureDetector(
                  onTap: () {
                    Get.offAll(const LoginScreen());
                  },
                  child: Text(
                    "تسجيل الدخول",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )),
                const SizedBox(width: 20,)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: AssetImage("assets/images/pattren.png"),
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.cover)),
                child: Row(
                  children: [
                    Container(
                      width: 70.sp,
                      height: 70.sp,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: const DecorationImage(
                              image: AssetImage("assets/samer.jpg"),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "كابتن سامر",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          "- مدرب، لياقه، فتنس، تغذية صحية Team NO1 ",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.grey.shade200),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              if (!isSubscribed)
                GestureDetector(
                  onTap: () async {

                    if(userController.user.value.id == null){
                      Get.to(const LoginScreen());
                    }

                    if(userController.user.value.id != null)
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                   
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xfff09819), Color(0xffedde5d)],
                                stops: [0, 1],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/premium.svg",
                                        color: Colors.white,
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "الاشتراك الذهبي",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => {Get.back()},
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      width: 25,
                                      height: 25,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "احصل على جميع المميزات",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(100)),
                                    width: 35,
                                    height: 35,
                                    child: const Icon(
                                      CupertinoIcons.square_list,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "كورس محترفين",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "يمكنك الوصول اليه دائما",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(100)),
                                    width: 35,
                                    height: 35,
                                    child: const Icon(
                                      CupertinoIcons.bag,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "نظام غذائي",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "نظام غذائي مخصص لجسم اللاعب",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(100)),
                                    width: 35,
                                    height: 35,
                                    child: const Icon(
                                      CupertinoIcons.chat_bubble,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "التواصل مع الكابتن",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "الحصول على الاستشارات من الكابتن",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(100)),
                                    width: 35,
                                    height: 35,
                                    child: const Icon(
                                      CupertinoIcons.flame,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "المكملات الغذائية",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "الحصول على الارشادات بخصوص المكملات الغذائية المناسبة",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                             
                            const SizedBox(
                                height: 25,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(171, 29, 59, 148),
                                    borderRadius: BorderRadius.circular(20)),
                                child: GestureDetector(
                                  onTap: () async {
                                    // final offerings = await Purchases.getProducts(
                                    //     ["golden_99_member_1m"]);
                                    // final offering = offerings.firstWhere(
                                    //     (element) =>
                                    //         element.identifier ==
                                    //         "golden_99_member_1m");
                        
                                    // final purchaserInfo =
                                    //     await Purchases.purchaseStoreProduct(
                                    //         offering);
                                    // // check if user is subscribed

                                    // if (purchaserInfo.entitlements.all["gold"]
                                    //         ?.isActive ==
                                    //     true) {
                                    //   userController.subscribe();
                                    //   setState(() {
                                    //     isSubscribed = true;
                                    //   });
                                    // }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "لمدة شهر 99.9\$",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "اشترك لفتح جميع المميزات",
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      // https://www.termsfeed.com/live/cba717a1-02c8-4673-ae3a-30ebab619ff4
                                      launchUrl(Uri.parse("https://www.termsfeed.com/live/cba717a1-02c8-4673-ae3a-30ebab619ff4"));
                                    },
                                    child: const Text("Privacy Policy",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            // underline: TextDecoration.underline,
                                            decoration: TextDecoration.underline,
                                            
                                            fontWeight: FontWeight.bold)),
                                  ),
                              const SizedBox(width: 5,),
                              const Text(","),
                               const SizedBox(width: 5,),
                               GestureDetector(
                                 onTap: () async{

                                  // https://www.termsfeed.com/live/cba717a1-02c8-4673-ae3a-30ebab619ff4
                                    await launchUrl(Uri.parse("https://www.app-privacy-policy.com/live.php?token=PwHW1HOMKrFotcFIEnpFNMusQ5aWouuC"));

                                 },
                                 child: const Text("Terms Of Service",
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 16,
                                         // underline: TextDecoration.underline,
                                         decoration: TextDecoration.underline,
                                         
                                         fontWeight: FontWeight.bold)),
                               ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [Color(0xfff7971e), Color(0xffffd200)],
                          stops: [0, 1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("الاشتراك",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                            const SizedBox(
                              width: 5,
                            ),
                            SvgPicture.asset(
                              "assets/premium.svg",
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("الذهبي",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                     userController.user.value.id != null ?   const Text(
                          "لفتح جميع مميزات التطبيق",
                          style: TextStyle(color: Colors.white),
                        ) :  const Text(
                          "سجل الدخول للحصول على اشتراكك",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                ),),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.only(
                      top: 0, bottom: 5, left: 20, right: 20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "العرروض المتوفرة",
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
              Container(
                margin: const EdgeInsets.only(
                    top: 0, bottom: 5, left: 20, right: 20),
                width: 100.sp,
                height: 3,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(100)),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(() => offerController.loadOffers.value
                  ? Container(
                      height: 330.sp,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      height: 330.sp,
                      child: Swiper(
                        layout: SwiperLayout.DEFAULT,
                        itemCount: offerController.offers.length,
                        itemWidth: MediaQuery.of(context).size.width,
                        itemHeight: 280.sp,
                        viewportFraction: 0.74,
                        scale: 0.9,
                        itemBuilder: (context, pos) {
                          return LoadingImage(
                              radius: 10,
                              image:
                                  offerController.offers[pos].url_image ?? "");
                        },
                      ),
                    )),
            ],
          ),)
        ),
      ),
    );
  }
}
