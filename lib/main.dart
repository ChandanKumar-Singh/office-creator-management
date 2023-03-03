import 'dart:async';

import 'package:creater_management/providers/dashBoardController.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'constants/app.dart';
import 'functions/functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. debug provider
    // 2. safety net provider
    // 3. play integrity provider
    androidProvider: AndroidProvider.playIntegrity,
  );

  await initFCM();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const CreatorManagementApp());
}

class CreatorManagementApp extends StatefulWidget {
  const CreatorManagementApp({Key? key}) : super(key: key);

  @override
  State<CreatorManagementApp> createState() => _CreatorManagementAppState();
}

class _CreatorManagementAppState extends State<CreatorManagementApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
            headline6: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 0,height: 1.0)),
            headline5: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 0)),
            headline4: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 0,height: 1.0)),
            headline3: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w400,letterSpacing: 0)),
            headline2: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 0)),
            headline1: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 0)),
            bodyText2: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w700,letterSpacing: 0,height: 1.0)),
            bodyText1: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w900,
                letterSpacing: 0,height: 1.0)),
            caption: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
            // caption: GoogleFonts.actor(),
          ),
          primarySwatch: MaterialColor(
            App.swatchCode,
            {
              50: const Color(App.swatchCode).withOpacity(0.1),
              100: const Color(App.swatchCode).withOpacity(0.2),
              200: const Color(App.swatchCode).withOpacity(0.3),
              300: const Color(App.swatchCode).withOpacity(0.4),
              400: const Color(App.swatchCode).withOpacity(0.5),
              500: const Color(App.swatchCode).withOpacity(0.6),
              600: const Color(App.swatchCode).withOpacity(0.7),
              700: const Color(App.swatchCode).withOpacity(0.8),
              800: const Color(App.swatchCode).withOpacity(0.9),
              900: const Color(App.swatchCode).withOpacity(1),
            },
          ),
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // if(MediaQuery.of(context).viewInsets.bottom != 0) {
    //   FocusManager.instance.primaryFocus?.unfocus();
    // }
    connectionSetup();
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Text(
              'wecollab ',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
      // body: Center(
      //   child: Image.asset(
      //     'assets/images/NOV-LOGO-red.png',
      //     width: Get.width / 2,
      //   ),
      // ),
    );
  }
}
