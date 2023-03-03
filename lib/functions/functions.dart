import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:creater_management/pages/homePage.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_data_api/helpers/extract_json.dart';
import 'package:youtube_data_api/helpers/helpers_extention.dart';
import 'package:html/parser.dart' as parser;
import '../constants/app.dart';
import '../constants/widgets.dart';
import '../pages/LoginScreen.dart';
import '../pages/completeProfile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_insta/flutter_insta.dart';

final oCcy = NumberFormat.simpleCurrency(name: '');

enum UserType { associate, customer }

///FCM
FirebaseMessaging messaging = FirebaseMessaging.instance;
String deviceToken = '';
String fcmWebServerKey =
    'AAAA45lGNRY:APA91bG4_gdMk8GM6oWe7wdX1pmQe-fI33-dkQ1K0tmdaClk-yDGmTWwedQjb1Hja_HM5ElxOyWOnRqOykAtgaK5rSe-fS7QgZghqdykLLyXI97rYKgd8w84KDCrEnZWWuJwkfh6gtiI';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);

Future<void> setupFCM() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint('User granted provisional permission');
  } else {
    debugPrint('User declined or has not accepted permission');
  }

  try {
    var token;
    if (Platform.isAndroid) {
      token = await messaging.getToken();
    }
    if (Platform.isIOS) {
      token = await messaging.getAPNSToken();
    }
    if (token != null) {
      deviceToken = token;
      debugPrint('FCM TOKEN IS $deviceToken');
    }
  } catch (e) {
    debugPrint('FEM TOKEN ERROR $e');
  }
}

Future<void> initFCM() async {
  ///init notification setup
  await setupFCM();

  ///initialise settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentSound: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    ),
    macOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
    ),
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) {
      print('onDidReceiveNotificationResponse ${response}');
    },
    // onDidReceiveBackgroundNotificationResponse: (response) async{
    // await firebaseMessagingBackgroundHandler(RemoteMessage());
    // print('onDidReceiveBackgroundNotificationResponse ${response}');
    // }
  );

  ///initialMessage
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    debugPrint('initialMessage -------> $initialMessage');
  }

  ///onMessageOpenedApp

  FirebaseMessaging.onMessageOpenedApp
      .listen((message) => debugPrint('onMessageOpenedApp -------> $message'));

  ///onMessage
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('onMessage Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint(
          'Message also contained a notification: ${message.notification}');
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      flutterLocalNotificationsPlugin.show(
          id,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'assets/images/instaLogo.png',
            ),
          ));
    }
  });
}

Future<void> saveTokenToDB(String token, String id) async {
  await FirebaseFirestore.instance
      .collection(App.appname)
      .doc(id)
      .set({'token': token}).then(
          (value) => debugPrint('Token saved to both Laravel Db'));
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

Route slideUpRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route slideLeftRoute(
  Widget page, {
  PageTransitionType? effect,
  int? period,
  Widget? current,
}) {
  return PageTransition(
      childCurrent: current,
      type: effect ?? PageTransitionType.fade,
      child: page,
      duration: Duration(milliseconds: period ?? 500));
}

String token = '';
bool isOnline = true;

bool profileCompleted = false;
bool onInsta = false;
bool onYoutube = false;
int instaFollowers = 0;
int ytSubscribers = 0;
bool underVerificationDialogShown = false;

bool updateAvailable = false;
// String appPackageName='com.crm.crm_application';
String appPackageName = 'com.crm.sca_crm';
String appPlayStoreUrl = '';
bool isLogin = false;
late SharedPreferences prefs;
var downloadedProfileImagePath = '';
late String appTempPath;
FirebaseAuth auth = FirebaseAuth.instance;
// final _checker = AppVersionChecker(appId: 'com.crm.sca_crm');

// Future<void> checkVersion() async {
//   try {
//     _checker.checkUpdate().then((value) {
//       // updateAvailable = value.canUpdate;
//       appPlayStoreUrl = value.appURL ?? '';
//       // if (value.newVersion != null) {
//       //   String _version = value.newVersion!;
//       //   debugPrint(_version);
//       //   debugPrint(value.canUpdate); //return true if update is available
//       //   debugPrint(value.currentVersion); //return current app version
//       //   debugPrint(value.newVersion); //return the new app version
//       //   debugPrint(value.appURL); //return the app url
//       //   debugPrint(value.errorMessage);
//       //   var version = _version.toString().split('.');
//       //   var package = value.currentVersion.toString().split('.');
//       //   // for (var i = 0; i < version.length || i < package.length; i++) {
//       //   //   if (i < version.length && i < package.length) {
//       //   //     if (int.parse(package[i]) < int.parse(version[i])) {
//       //   //       updateAvailable = true;
//       //   //       break;
//       //   //     } else if (int.parse(package[i]) > int.parse(version[i])) {
//       //   //       updateAvailable = false;
//       //   //       break;
//       //   //     }
//       //   //   } else if (i >= version.length && i < package.length) {
//       //   //     updateAvailable = false;
//       //   //     break;
//       //   //   } else if (i < version.length && i >= package.length) {
//       //   //     updateAvailable = true;
//       //   //     break;
//       //   //   }
//       //   // }
//       // }
//
//       //return error message if found else it will return null
//     });
//   } catch (e) {
//     debugPrint('App update check error $e');
//   }
// }

void connectionSetup() async {
  // var connection = await Connectivity().checkConnectivity();
  // isOnline = connection != ConnectivityResult.none;
  //
  // Connectivity().onConnectivityChanged.listen((event) {
  //   isOnline = event != ConnectivityResult.none;
  //   debugPrint(' now we are online $isOnline');
  //   showNetWorkToast();
  // });
}

void checkLogin() async {
  prefs = await SharedPreferences.getInstance();
  appTempPath = (await getTemporaryDirectory()).path;
  // if (isOnline) {
  //   var user = auth.currentUser;
  //   debugPrint('check login online user $user');
  //   if (user != null) {
  //     isLogin = true;
  //   }
  // } else {
  bool? login = prefs.getBool('isLogin');
  debugPrint('check login offline user $login');
  if (login != null && login) {
    isLogin = true;
    // }
  } else {
    isLogin = false;
  }
  Timer(const Duration(seconds: 0), () async {
    if (!isLogin) {
      Get.offAll(const LoginScreen());
    } else {
      await initiateUser(fastLogin: true);
      // Get.offAll(const LoginScreen());
    }
  });
}

Future<int> getYouTubeSubscribers(
    {required String videoId, required String channelName}) async {
  int followers = 0;
  try {
    var client = http.Client();
    var response = await client.get(Uri.parse(videoId));
    // var response = await client.get(Uri.parse(
    // 'https://www.youtube.com/watch?v=$videoId&ab_channel=$channelName'));
    var raw = response.body;
    var root = parser.parse(raw);
    final scriptText = root
        .querySelectorAll('script')
        .map((e) => e.text)
        .toList(growable: false);
    var initialData =
        scriptText.firstWhereOrNull((e) => e.contains('var ytInitialData = '));
    initialData ??= scriptText
        .firstWhereOrNull((e) => e.contains('window["ytInitialData"] ='));
    var jsonMap = extractJson(initialData!);
    if (jsonMap != null) {
      var contents = jsonMap.get('contents')?.get('twoColumnWatchNextResults');

      var item = contents
          ?.get('results')
          ?.get('results')
          ?.getList('contents')
          ?.firstWhere((element) => element.keys
              .any((element) => element == 'videoSecondaryInfoRenderer'))
          .get('videoSecondaryInfoRenderer')
          ?.get('owner')
          ?.get('videoOwnerRenderer')
          ?.get('subscriberCountText')
          ?.get('accessibility')
          ?.get('accessibilityData')?['label'];
      if (item != null) {
        followers = getSubscribersCount(item);
      }
      debugPrint('*********************************** $item');
    }
  } catch (e) {
    debugPrint('9999999999999999 $e');
  }
  return followers;
}

int getSubscribersCount(String text) {
  var realCount = 0;
  debugPrint(text);
  if (text.contains('million')) {
    realCount = (double.parse(text.split(' ').first) * 1000000).toInt();
  } else if (text.split(' ').first.contains('k') ||
      text.split(' ').first.contains('K')) {
    var amountText = text.split(' ').first.split('');
    var removed = amountText.remove('K');
    if (!removed) {
      amountText.remove('k');
    }
    realCount = (double.parse(amountText.join('')) * 1000).toInt();
  } else {
    realCount = double.parse(text.split(' ').first).toInt();
  }
  debugPrint('real count $realCount');
  return realCount;
}

//     // String url = "https://www.instagram.com/";
//     // var username = 'sumit7376sharma';
//     // var res = await http.
//     // get(Uri.parse('https://www.youtube.com/watch?v=y2tEPmwWEiI&ab_channel=ThraceMusic'));
//     //     // .get(Uri.parse('https://www.googleapis.com/youtube/v3/videos?id=7lCDEYXw3mM&key=$youTubeApiKey'));
//     // debugPrint('data from insta package ${res.body}');
//     // // var data = json.decode(res.body);
//     // // debugPrint('data from insta package $data');
//     // FlutterInsta flutterInsta = FlutterInsta();
//     // await flutterInsta.getProfileData("sumit7376sharma");
//     // followers=flutterInsta.followers??'0';
//     // debugPrint("Username : ${flutterInsta.username}");
//     // debugPrint("Followers : ${flutterInsta.followers}");
//     // debugPrint("Folowing : ${flutterInsta.following}");
//     // debugPrint("Bio : ${flutterInsta.bio}");
//     // debugPrint("Website : ${flutterInsta.website}");
//     // debugPrint("Profile Image : ${flutterInsta.imgurl}");
//     // debugPrint("Feed images:${flutterInsta.feedImagesUrl}");
//   } catch (e) {
//     debugPrint('insta followers error $e');
//   }
//   return followers;
// }
// const String youTubeApiKey ='AIzaSyBXnb_cmv6UtDqSEE_1glg4r5h1y_Y5RWg';
// Future<int> getYtSubscribers(String channelID) async {
//   debugPrint('video subscriber count ');
//   int subscribers = 0;
//   try {
//     YoutubeDataApi youtubeDataApi = YoutubeDataApi();
//     // List<Video> videos = await youtubeDataApi.fetchTrendingVideo();
//     // debugPrint(videos.length);
//     //
//     // VideoData? videoData = await youtubeDataApi
//     //     .fetchVideoData('y2tEPmwWEiI&ab_channel=ThraceMusic');
//     var client = http.Client();
//     var response = await client.get(
//       Uri.parse(
//         'https://www.youtube.com/channel/$channelID/videos',
//       ),
//     );
//     var raw = response.body;
//     var root = parser.parse(raw);
//     final scriptText = root
//         .con('script')
//         .map((e) => e.text)
//         .toList(growable: false);
//     var initialData =
//     scriptText.firstWhereOrNull((e) => e.contains('var ytInitialData = '));
//     debugPrint("initialData : ${root.body}");
//     debugPrint('this channelid data has  $channelID ');
//     // ChannelData? channelData =
//     //     await youtubeDataApi.fetchChannelData(channelID);
//     // debugPrint('this channel data has  $channelData ');
//
//     // if (channelData != null) {
//     //   subscribers = int.parse(channelData.channel.subscribers ?? '0');
//     // } else {
//     //   debugPrint('this channel data has null $channelData');
//     // }
//     // String? videoTitle = videoData?.video?.title;
//     // String? videoChannelName = videoData?.video?.channelName;
//     // String? viewsCount = videoData?.video?.viewCount;
//     // String? likeCount = videoData?.video?.likeCount;
//     // String? channelThumbnail = videoData?.video?.channelThumb;
//     // String? channelId = videoData?.video?.channelId;
//     // String? subscribeCount = videoData?.video?.subscribeCount;
//     // List<Video?>? relatedVideos = videoData?.videosList;
//     // debugPrint('video subscriber count =${videoData}');
//   } catch (e) {
//     debugPrint('youtube api getting subscribers error $e');
//   }
//   return subscribers;
// }

Future<int> getInstaSubscribers(String username) async {
  var followers = 0;
  try {
    FlutterInsta flutterInsta = FlutterInsta();
    // await flutterInsta.getProfileData("sumit7376sharma"); //instagram username
    await flutterInsta.getProfileData("apnamotiv"); //instagram username
    // await flutterInsta.getProfileData(username); //instagram username
    debugPrint(flutterInsta.followers);

    followers = int.parse(flutterInsta.followers ?? '0');
  } catch (e) {
    debugPrint('insta error $e');
  }
  return followers;
}

Future<XFile?> pickImage(ImageSource source) async {
  var image = await ImagePicker().pickImage(source: source);
  return image;
}

Future<void> initiateUser(
    {String? id, String? pass, bool? route, bool fastLogin = false}) async {
  Provider.of<AuthProvider>(Get.context!, listen: false).phoneController.text =
      id ?? prefs.getString('phone')!;

  await Provider.of<AuthProvider>(Get.context!, listen: false)
      .login(route: route ?? true, fastLogin: fastLogin);
}

bool isProfileCompleted(UserProvider up) {
  if (up.creator.data!.firstName != null &&
      up.creator.data!.address != null &&
      ((up.creator.data!.insta_username != null &&
              up.creator.data!.instaFollowers != 0) ||
          (up.creator.data!.youtubeUrl != null &&
              up.creator.data!.youtubeSubscribers != 0))) {
    debugPrint(
        '0000000000000000000000000000000000000 isProfileCompleted pushing');
    Get.offAll(const HomePage());
    return true;
  } else {
    Get.offAll(const CompleteProfilePage());
    return false;
  }
}

bool isQualified(String type, int quantity) {
  bool isQlf = false;
  if (type == 'Youtube') {
    if (ytSubscribers >= quantity) {
      isQlf = true;
    } else {
      // Fluttertoast.showToast(msg: 'You are not eligible\n$quantity $type subscribers required');
    }
  } else {
    if (instaFollowers >= quantity) {
      isQlf = true;
    } else {
      // Fluttertoast.showToast(msg: 'You are not eligible\n$quantity $type followers required');
    }
  }
  return isQlf;
}

Future downloadAndSaveProfileImage(String url, String savePath) async {
  try {
    var response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    debugPrint('downloadAndSaveProfileImage error ---> $e');
  }
}

void showNetWorkToast({String? msg}) {
  if (!isOnline) {
    Fluttertoast.showToast(
        msg: msg ??
            " ${isOnline ? "👍" : "🤦‍♂️"} You are  ${isOnline ? "Online back" : "Offline now"}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: isOnline
            ? Colors.green.withOpacity(0.5)
            : Colors.red.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

void showNotVerifiedDialog(bool verified, bool back) {
  if (!verified) {
    AwesomeDialog(
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: false,
        context: Get.context!,
        dialogType: DialogType.info,
        titleTextStyle: const TextStyle(color: Colors.red, fontSize: 20),
        title: '\nYou are not verified yet',
        btnOkText: 'O K',
        btnOkOnPress: () {
          // if (Platform.isAndroid) {
          //   SystemNavigator.pop();
          //
          // } else if (Platform.isIOS) {
          //   exit(0);
          // }
          if (back) {
            Navigator.pop(Get.context!);
          }
        }).show();
  }
}

void showUnderVerificationDialog() {
  if (Provider.of<UserProvider>(Get.context!, listen: false)
              .creator
              .data!
              .status !=
          "Active" &&
      !underVerificationDialogShown) {
    Timer(const Duration(seconds: 1), () {
      underVerificationDialogShown = true;
      showDialog(
          context: Get.context!,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                // height: 400,
                width: Get.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Stack(
                              children: [
                                Container(
                                  // height: 300,
                                  // padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      h4Text(
                                        'Notice',
                                        fontWeight: FontWeight.bold,
                                        color: App.themecolor,
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: capText(
                                              'Thank you for register with us, your account is under review by backend team, once it will be approved you can participate in collab.',
                                              color: Colors.black,
                                            ))
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: h6Text(
                                            '\nThank you',
                                            color: Colors.blue,
                                            textAlign: TextAlign.center,
                                          ))
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: double.maxFinite,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15)),
                                            color: App.themecolor,
                                          ),
                                          child: Center(
                                            child: h5Text(
                                              'OK',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Image.asset(
                        //       'assets/images/review.png',
                        //       height: 150,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}

String timeBefore(String time) {
  var dt = '';
  var ct = DateTime.now();
  var duration = ct.difference(DateTime.parse(time));
  if (duration.inDays > 0) {
    dt = '${duration.inDays}d';
  } else if (duration.inHours > 0 && duration.inHours < 24) {
    dt = '${duration.inHours}h';
  } else if (duration.inMinutes > 0 && duration.inMinutes < 60) {
    dt = '${duration.inMinutes}min';
  } else if (duration.inSeconds > 0 && duration.inSeconds < 60) {
    dt = '${duration.inSeconds}s';
  }
  return dt;
}

String countInKMB(String count) {
  String kmbCount = '';
  int ct = int.parse(count);
  print('ct is $ct');

  if (ct > 999 && ct < 999999) {
    kmbCount = '${(ct / 1000).toStringAsFixed(2)}K';
  } else if (ct > 999999 && ct < 9999999) {
    kmbCount = '${(ct / 1000000).toStringAsFixed(2)}M';
  } else if (ct > 9999999 && ct < 999999999) {
    kmbCount = '${(ct / 1000000000).toStringAsFixed(2)}B';
  } else if (ct > 1000000000) {
    kmbCount = '${(ct / 1000000000).toStringAsFixed(2)}B+';
  } else {
    kmbCount = count;
  }
  return kmbCount;
}

void hoverLoadingDialog(loading) async {
  if (loading) {
    await showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: Get.width / 2 - 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: CircularProgressIndicator(
                    // color: Colors.white,
                    ),
              ),
            ),
          );
        });
  } else {
    Get.back();
  }
}

///Timer String
String timerString(int duration) {
  var min = '0';
  var sec = '0';
  if (duration > 0 && duration < 60) {
    sec = duration.toString();
  } else if (duration / 60 > 1) {
    min = (duration ~/ 60).toString();
    sec = (duration % 60).toInt().toString();
  }
  var elapsed = '$min:$sec';

  return elapsed;
}

bool blr = false;
void hoverBlankLoadingDialog(loading, [bool gif = false]) async {
  if (loading) {
    blr = true;
    await showDialog(
        barrierDismissible: false,
        context: Get.context!,
        barrierColor: Colors.black54,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: Get.width / 2 - 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: gif
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Image.asset(
                            'assets/images/time_loading_no_bg.gif',
                            fit: BoxFit.cover),
                      )
                    : LoadingBouncingGrid.square(
                        borderColor: Get.theme.colorScheme.primary,
                        borderSize: 3.0,
                        size: 30.0,
                        inverted: false,
                        backgroundColor: Colors.white,
                        duration: const Duration(milliseconds: 2000),
                      ),
              ),
            ),
          );
        });
  } else {
    blr = false;
    Get.back();
  }
}

void showShortSheetActions(
    {required double width,
    required double height,
    double? radius,
    Color? color,
    Widget? child,
    EdgeInsetsGeometry? padding}) async {
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      context: Get.context!,
      isDismissible: false,
      builder: (context) {
        return Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10),
            boxShadow: [
              BoxShadow(
                  color: Get.theme.primaryColor.withOpacity(0.6),
                  // color:Colors.red,
                  offset: const Offset(1, 1),
                  blurRadius: 15,
                  spreadRadius: 10),
            ],
            color:
                color ?? Color(Get.theme.indicatorColor.value).withOpacity(0.7),
          ),
          margin: EdgeInsets.only(
            left: (Get.width - width) / 2,
            right: (Get.width - width) / 2,
            bottom: (Get.height - height) / 2,
          ),
          child: child,
        );
      });
}

// Future<bool?> callNumber(String number) async {
//   return await FlutterPhoneDirectCaller.callNumber(number);
// }

// Future<void> pickImageDialog(UserProvider up) async {
//   return showShortSheetActions(
//     width: Get.width * 0.4,
//     height: 100,
//     color: Get.theme.colorScheme.primary,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         GestureDetector(
//           onTap: () async {
//             Get.back();
//             var image = await pickImage(ImageSource.camera);
//             if (image != null) {
//               up.imageFile = image;
//               await up.updateImage();
//             }
//             debugPrint('${up.imageFile} this is picked image');
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               const Icon(
//                 Icons.camera,
//                 color: Colors.white,
//                 size: 50,
//               ),
//               Row(
//                 children: [
//                   b1Text('Camera',
//                       color: Colors.white, textAlign: TextAlign.center),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         GestureDetector(
//           onTap: () async {
//             Get.back();
//             var image = await pickImage(ImageSource.gallery);
//             if (image != null) {
//               up.imageFile = image;
//               await up.updateImage();
//             }
//             debugPrint('${up.imageFile} this is picked image');
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               const Icon(
//                 Icons.photo_library_sharp,
//                 color: Colors.white,
//                 size: 50,
//               ),
//               Row(
//                 children: [
//                   b1Text('Gallery',
//                       color: Colors.white, textAlign: TextAlign.center),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
