import 'dart:async';
import 'dart:convert';

import 'package:creater_management/models/createrModel.dart';
import 'package:creater_management/pages/LoginScreen.dart';
import 'package:creater_management/pages/homePage.dart';
import 'package:creater_management/pages/completeProfile.dart';
import 'package:creater_management/providers/dashBoardController.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../constants/app.dart';
import '../functions/functions.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  OtpFieldController otpFieldController = OtpFieldController();

  TextEditingController otpEditingController = TextEditingController();
  var messageOtpCode = '';

  bool otpSent = false;
  int otpSentCount = 0;
  final int resendTimeOut = 10;
  int resendTimer = 10;
  late Timer timer;

  String verificationId = '';

  Future<void> sendOtp() async {
    hoverBlankLoadingDialog(true);

    if (isOnline) {
      notifyListeners();
      try {
        await auth
            .verifyPhoneNumber(
                phoneNumber: '+91${phoneController.text}',
                timeout: Duration(seconds: resendTimeOut),
                verificationCompleted: (credentials) {},
                verificationFailed: (exception) {
                  verificationId = '';
                  otpSent = false;
                  notifyListeners();
                  Fluttertoast.showToast(msg: exception.message!);
                  if (blr) {
                    hoverBlankLoadingDialog(false);
                  }
                },
                codeSent: (message, newToken) {
                  verificationId = message;
                  otpSentCount++;
                  otpSent = true;
                  notifyListeners();
                  debugPrint('Oteeep sent $otpSent  message $message');
                  if (blr) {
                    hoverBlankLoadingDialog(false);
                  }
                  Navigator.push(
                      Get.context!,
                      MaterialPageRoute(
                          builder: (context) => const OtpScreen()));
                  Future.delayed(
                      const Duration(seconds: 1),
                      () => Fluttertoast.showToast(
                          msg:
                              'A OTP has sent to your registered mobile number'));
                },
                codeAutoRetrievalTimeout: (reason) {
                  // verificationId = '';
                  otpSent = false;
                  notifyListeners();
                  debugPrint('codeAutoRetrievalTimeout $reason');
                  if (blr) {
                    hoverBlankLoadingDialog(false);
                  }
                  Fluttertoast.showToast(msg: 'Time out for otp verification');
                })
            .then((value) {});
        // } else {
        //   Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
        // }
        // hoverLoadingDialog(false);
        // } else {
        //   hoverLoadingDialog(false);
        //
        //   debugPrint(res.body.toString());
        // }

      } catch (e) {
        debugPrint(e.toString());
        if (blr) {
          hoverBlankLoadingDialog(false);
        }
      }
    } else {
      showNetWorkToast(msg: 'You are offline. Please connect to network');
    }
    debugPrint('otp count $otpSentCount  otp sent $otpSent');
    debugPrint(blr.toString());
    // if (blr) {
    // Future.delayed(Duration(seconds: 1),()=>  hoverBlankLoadingDialog(false));
    // }
  }

  Future<void> otpVerification() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpController.text);
    if (isOnline) {
      try {
        if (verificationId.isEmpty) {
          Fluttertoast.showToast(msg: 'Otp has not send yet. ');
        } else if (otpController.text.isEmpty) {
          Fluttertoast.showToast(msg: 'Please enter otp');
        } else {
          hoverBlankLoadingDialog(true);
          var user = await auth.signInWithCredential(credential);
          otpController.clear();
          otpFieldController.clear();
          if (user.user != null) {
            Provider.of<UserProvider>(Get.context!, listen: false)
                .phoneController
                .text = phoneController.text;
            otpSent = false;
            verificationId = '';

            notifyListeners();
            if (blr) {
              hoverBlankLoadingDialog(false);
            }
            var res = await login(imLogging: true, route: true);
          }

          debugPrint(user.toString());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'session-expired') {
          Fluttertoast.showToast(msg: e.message!);
        } else if (e.code == 'invalid-verification-code') {
          Fluttertoast.showToast(msg: e.message!);
        }
        otpController.clear();
        otpFieldController.clear();
        debugPrint('FirebaseAuthException  verificaton $e');
      }
    } else {
      otpController.clear();
      otpFieldController.clear();
      showNetWorkToast(msg: 'You are offline. Please connect to network');
    }
    debugPrint('otp count $otpSentCount  otp sent $otpSent');
    if (blr) {
      hoverBlankLoadingDialog(false);
    }
    otpController.clear();
    otpFieldController.clear();
  }

  late Timer _timer;
  int otpTimeOutDuration = 90;
  String? resOtp;
  void otpTimeOut() {
    otpTimeOutDuration = 90;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimeOutDuration == 0) {
        _timer.cancel();
        otpTimeOutDuration = 0;
      } else {
        otpTimeOutDuration--;
      }
      notifyListeners();
    });
  }

  Future<void> sendOtpApi(String number,
      {required bool otpScreen, bool replace = false}) async {
    hoverBlankLoadingDialog(true);

    if (isOnline) {
      notifyListeners();
      var appSignatureID = await SmsAutoFill().getAppSignature;
      Map sendOtpData = {
        "mobile_number": number,
        "app_signature_id": appSignatureID
      };
      print(sendOtpData);
      try {
        var url = App.liveBaseUrl + App.sendOTP;
        var headers = {'Content-Type': 'application/json'};
        var body = {"phone": number, "app_signature_id": appSignatureID};
        debugPrint('sendOtpApi parameters $body');
        var res = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(body));
        debugPrint('sendOtpApi  ${res.body}');
        var response = jsonDecode(res.body);
        hoverBlankLoadingDialog(false);
        if (res.statusCode == 200) {
          if (response['data'] != null) {
            //TODO: SMS Auto fill
            otpSent = true;
            resOtp = response['data']['data'].toString();
            notifyListeners();
            // if(_timer.isActive) {
            //   _timer.cancel();
            // }
            await SmsAutoFill().listenForCode();
            otpTimeOut();
            if (!otpScreen) {
              replace
                  ? Navigator.pushReplacement(
                      Get.context!,
                      MaterialPageRoute(
                          builder: (context) => const OtpScreen()))
                  :
                  // MaterialPageRoute(builder: (context) => const OTPVIEW())):
                  Navigator.push(
                      Get.context!,
                      MaterialPageRoute(
                          builder: (context) => const OtpScreen()));
              // MaterialPageRoute(builder: (context) => const OTPVIEW()));
            }
            Future.delayed(
                const Duration(seconds: 1),
                () => Fluttertoast.showToast(
                    msg: 'A OTP has sent to your registered mobile number'));
          } else {
            otpSent = false;
            _timer.cancel();
            notifyListeners();
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        } else {
          otpSent = false;
          _timer.cancel();
          notifyListeners();
          Fluttertoast.showToast(msg: 'Some thing went wrong.');
        }
      } catch (e) {
        debugPrint('sendOtpApi ERROR $e');
        otpSent = false;
        _timer.cancel();
        notifyListeners();
        if (blr) {
          hoverBlankLoadingDialog(false);
        }
      }
    } else {
      showNetWorkToast(msg: 'You are offline. Please connect to network');
    }
  }

  Future<dynamic> login(
      {bool? imLogging, bool? route, bool fastLogin = false}) async {
    var response;
    try {
      bool cacheExist = await APICacheManager().isAPICacheKeyExist('login');
      debugPrint(' i am loging = $imLogging');
      if (imLogging != null && imLogging) {
        hoverBlankLoadingDialog(true);
      }

      if (isOnline && !fastLogin) {
        debugPrint(' this is fast loging = $fastLogin');
        var url = App.liveBaseUrl + App.login;
        var headers = {'Content-Type': 'application/json'};
        var body = {"phone": phoneController.text, "device_token": deviceToken};

        debugPrint('login parameters $body');
        var res = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(body));
        debugPrint('login api ${res.body}');
        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['status'] == 200) {
            var cacheModel = APICacheDBModel(key: 'login', syncData: res.body);
            await APICacheManager().addCacheData(cacheModel);
            response = jsonDecode(res.body);
            if (response['results']['data']['profile_pic'] != null &&
                response['results']['data']['profile_pic'] != '') {
              await downloadAndSaveProfileImage(
                  response['results']['data']['profile_pic'],
                  '$appTempPath/${response['results']['data']['profile_pic'].split('/').last}');
            }
            await prefs.setString('phone', phoneController.text);
          } else {
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        }
        // debugPrint("it's url Hit ${response['results']['data']}");
      } else {
        if (!isOnline) {
          showNetWorkToast();
        }
        if (cacheExist) {
          response = jsonDecode(
              (await APICacheManager().getCacheData('login')).syncData);
          // debugPrint("it's cache Hit");
          // debugPrint("it's cache Hit ${response['results']['data']}");
        }
      }

      if (response != null) {
        var up = Provider.of<UserProvider>(Get.context!, listen: false);
        var dp = Provider.of<DashboardProvider>(Get.context!, listen: false);
        debugPrint('creating user');
        debugPrint('creating user results ${response['results']}');
        up.creator = Creator.fromJson(response['results']);
        debugPrint('created user');

        if (up.creator.data!.instaFollowers! > 0) {
          onInsta = true;
          instaFollowers = up.creator.data!.instaFollowers!;
        }
        if (up.creator.data!.youtubeSubscribers! > 0) {
          onYoutube = true;
          ytSubscribers = up.creator.data!.youtubeSubscribers!;
        }
        debugPrint('created user successfully');
        await up.initRecommendedBio();
        token = response['results']['token'];
        await prefs.setString('token', token);
        debugPrint('is route enabled  $route ');
        await dp.getGenres();
        if (route != null && route) {
          profileCompleted = isProfileCompleted(up);
          var dp = Provider.of<DashboardProvider>(Get.context!, listen: false);
          dp.setBottomIndex(1);
          // dp.setBottomIndex(0);
          debugPrint('is profile completed $profileCompleted');
          phoneController.clear();
          otpController.clear();
        }
        isLogin = true;
        await prefs.setBool('isLogin', isLogin);
        notifyListeners();
        try {
          dp.getTasks();
          dp.getResTasks();
          dp.getWallTasks();
          dp.getUserTasksHistory();
        } catch (e) {
          debugPrint('This is ogin extra error $e');
        }
      }
    } catch (e) {
      debugPrint(' login e e e e e e e -> $e');
    }
    // debugPrint('testing login ------ > $imLogging    $response');

    if (imLogging != null && !isOnline) {
      response = null;
    }
    if (imLogging != null) {
      debugPrint('making loading false');
      hoverBlankLoadingDialog(false);
    }
    return response;
  }

  Future<void> logOut() async {
    if (isOnline) {
      await auth.signOut();
      if (auth.currentUser == null) {
        await prefs.setBool('isLogin', false);
        await prefs.remove('phone');
        await APICacheManager().emptyCache();
        Get.offAll(const LoginScreen());
      }
    } else {
      showNetWorkToast();
    }
  }
}
