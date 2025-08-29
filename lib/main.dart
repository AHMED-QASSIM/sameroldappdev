import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
//import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smaergym/core/services/auth_services.dart';
import 'package:smaergym/screens/admin/dashboard/dashboard.dart';
import 'package:smaergym/screens/dashboard/dashboard.dart';
import 'package:smaergym/screens/home/home_screen.dart';

import 'core/config/binding.dart';
import 'core/config/size_config.dart';
import 'core/themes/app_theme_light.dart';
import 'core/themes/theme_generator.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io' show Platform;


Future<void> initPlatformState() async {
  // await Purchases.setLogLevel(LogLevel.debug);

  // PurchasesConfiguration configuration;
  //   configuration = PurchasesConfiguration("appl_LUqcvKvQGIqkNTlLmeMGSwGyuOg");
  
  // await Purchases.configure(configuration);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initPlatformState();

  var user = await FirebaseAuth.instance.currentUser;
  if (user == null) {
    runApp(const MyApp(
      page: HomeScreen(),
    ));
  } else {
    var checkADmin = await AuthServices()
        .checkAdmin(await AuthServices().getUserPhone(user.uid));
    if (!checkADmin) {}
    runApp(
        MyApp(page: checkADmin ? const AdminDashboard() : const Dashboard()));
  }
}

class MyApp extends StatelessWidget {
  final Widget page;
  const MyApp({Key? key, required this.page}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          designSize: const Size(360, 690),
          builder: (context, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: child,
              initialBinding: BindingsController(),
              locale: const Locale("ar"),
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [const Locale('en'), const Locale('ar')],
              title: 'Flutter Demo',
              fallbackLocale: const Locale('ar'),
              theme: ThemeGenerator.generate(AppTheme()),
              darkTheme: ThemeGenerator.generate(AppTheme()),
            );
          },
          child: page,
        );
      });
    });
  }
}
