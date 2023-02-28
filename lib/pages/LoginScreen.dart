import 'package:creater_management/constants/app.dart';
import 'package:creater_management/constants/widgets.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:otp_autofill/otp_autofill.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../functions/functions.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, ap, _) {
      return Scaffold(
        backgroundColor: App.themecolor,
        body: Stack(
          children: [
            SizedBox(height: Get.height, width: Get.width),
            Positioned(
              bottom: 0,
              child: ClipPath(
                // clipper: WaveClipperOne(flip: false, reverse: true),
                child: Container(
                  height: Get.height - MediaQuery.of(context).viewInsets.bottom,
                  width: Get.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    App.themecolor,
                    App.themecolor1,
                  ])),
                ),
              ),
            ),
            Container(
              height: Get.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash_bg.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom <= 10
                  ? Get.height * 0.05
                  : 0,
              child: Container(
                height: Get.height * 0.6,
                width: Get.width,
                // color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    h3Text(
                      'Hello',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    h3Text(
                      'Creators',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: ap.phoneController,
                          cursorHeight: 25,
                          keyboardType: TextInputType.phone,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          onChanged: (val) {
                            if (val.length > 10) {
                              setState(() {
                                ap.phoneController.text = val.substring(0, 10);
                              });
                            }
                            if (val.length == 10) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 10, top: 20, bottom: 20),
                            hintText: 'Enter Mobile No.',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[200],
                              fontSize: 20,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () async {
                                if (ap.phoneController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'Please enter your mobile number');
                                } else if (ap.phoneController.text.length >
                                        10 ||
                                    ap.phoneController.text.length < 10) {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Please enter a valid mobile number');
                                } else if (ap.phoneController.text
                                    .contains('.')) {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Please enter a valid mobile number');
                                } else {
                                  // await ap.sendOtp().then((value) {
                                  await ap
                                      .sendOtpApi(ap.phoneController.text,
                                          otpScreen: false)
                                      .then((value) {
                                    debugPrint('Otp sent ${ap.otpSent}');
                                    if (ap.otpSent) {}
                                  });
                                }
                              },
                              child: SizedBox(
                                // height: 50,
                                // width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // height: 20,

                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        // borderRadius: BorderRadius.circular(100),
                                        // color: ap.phoneController.text.isEmpty?Colors.transparent:Colors.grey[400],
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      // child: Center(
                                      //     child: h6Text(
                                      //   'Login',
                                      //   fontWeight: FontWeight.bold,
                                      //   color: Colors.white,
                                      // )),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                    const Spacer(),
                    if (MediaQuery.of(context).viewInsets.bottom <= 10)
                      Column(
                        children: [
                          // SizedBox(height: Get.height * 0.1),
                          SizedBox(
                            width: Get.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                b1Text(
                                  'Partnership',
                                  color: Colors.white54,
                                  fontWeight: FontWeight.normal,
                                ),
                                const SizedBox(height: 5),
                                Image.asset(
                                  'assets/images/LIGHT-LOGO.png',
                                  width: 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  @override
  void codeUpdated() {
    var ap = Provider.of<AuthProvider>(context, listen: false);
    ap.messageOtpCode = code!;
    ap.otpEditingController.text = code!;
  }

  @override
  void initState() {
    super.initState();
    SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("unregisterListener");
    super.dispose();
  }

  final scaffoldKey = GlobalKey();

  /*
  @override
  void initState() {
    super.initState();
    // _otpInteractor = OTPInteractor();
    // _otpInteractor
    //     .getAppSignature()
    //     //ignore: avoid_print
    //     .then((value) => print('signature - $value'));
    //
    // controller = OTPTextEditController(
    //   codeLength: 6,
    //   //ignore: avoid_print
    //   onCodeReceive: (code) {
    //     print('Your Application receive code - $code  ${code.split('')}');
    //     Provider.of<AuthProvider>(context, listen: false)
    //         .otpFieldController
    //         .set(code.split(''));
    //   },
    //   otpInteractor: _otpInteractor,
    // )..startListenUserConsent(
    //     (code) {
    //       final exp = RegExp(r'(\d{6})');
    //       return exp.stringMatch(code ?? '') ?? '';
    //     },
    //     strategies: [
    //       // SampleStrategy(),
    //     ],
    //   );
  }

  @override
  Future<void> dispose() async {
    // await controller.stopListen();
    super.dispose();
  }

   */

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, ap, _) {
      return Scaffold(
        backgroundColor: App.themecolor,
        body: Stack(
          children: [
            SizedBox(height: Get.height, width: Get.width),
            Positioned(
              bottom: 0,
              child: ClipPath(
                // clipper: WaveClipperOne(flip: false, reverse: true),
                child: Container(
                  height: Get.height - MediaQuery.of(context).viewInsets.bottom,
                  width: Get.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    App.themecolor,
                    App.themecolor1,
                  ])),
                ),
              ),
            ),
            Container(
              height: Get.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash_bg.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom <= 10
                  ? Get.height * 0.05
                  : 0,
              child: Container(
                height: Get.height * 0.6,
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: h4Text(
                            'Good to see you',
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Get.width / 2,
                          child: PinFieldAutoFill(
                            autoFocus: true,
                            cursor: Cursor(color: Colors.white, enabled: true),
                            codeLength: 4,
                            textInputAction: TextInputAction.done,
                            controller: ap.otpEditingController,
                            decoration: const UnderlineDecoration(
                              textStyle:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              colorBuilder: FixedColorBuilder(Colors.white),
                              lineHeight: 4,
                              lineStrokeCap: StrokeCap.round,
                              // bgColorBuilder:
                              //     FixedColorBuilder(Colors.grey.withOpacity(0.2)),
                            ),
                            currentCode: ap.messageOtpCode,
                            onCodeSubmitted: (code) {},
                            onCodeChanged: (code) async {
                              ap.messageOtpCode = code!;
                              if (code.length == 4) {
                                print('this is code ${ap.messageOtpCode}');
                                if (ap.resOtp == code) {
                                  hoverBlankLoadingDialog(true);
                                  Provider.of<UserProvider>(Get.context!,
                                          listen: false)
                                      .phoneController
                                      .text = ap.phoneController.text;
                                  ap.otpSent = false;
                                  setState(() {});
                                  if (blr) {
                                    hoverBlankLoadingDialog(false);
                                  }
                                  var res = await ap.login(
                                      imLogging: true, route: true);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Otp is not valid. Try again');
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Enter four digit OTP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          // style: ElevatedButton.styleFrom(
                          //     elevation: 1,
                          //     backgroundColor: Colors.white,
                          //  ),
                          onPressed: () async {
                            // await ap.sendOtp();
                            ap.otpEditingController.clear();
                            ap.messageOtpCode = '';
                            // ap.otpController.clear();
                            await ap.sendOtpApi(ap.phoneController.text,
                                otpScreen: false, replace: true);
                          },
                          child: b1Text(
                            ap.otpTimeOutDuration == 0
                                ? 'Resend OTP'
                                : timerString(ap.otpTimeOutDuration),
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (MediaQuery.of(context).viewInsets.bottom <= 10)
                      Column(
                        children: [
                          // if (ap.verificationId == '')
                          // SizedBox(height: Get.height * 0.1),
                          // const Spacer(),
                          SizedBox(
                            width: Get.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                b1Text(
                                  'Partnership',
                                  color: Colors.white54,
                                  fontWeight: FontWeight.normal,
                                ),
                                const SizedBox(height: 5),
                                Image.asset(
                                  'assets/images/LIGHT-LOGO.png',
                                  width: 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class HomeController extends GetxController {
  CountdownController countdownController = CountdownController();
  TextEditingController otpEditingController = TextEditingController();
  var messageOtpCode = ''.obs;
  @override
  void onInit() async {
    super.onInit();
    print(await SmsAutoFill().getAppSignature);
    // Listen for SMS OTP
    await SmsAutoFill().listenForCode();
  }

  @override
  void onReady() {
    super.onReady();
    countdownController.start();
  }

  @override
  void onClose() {
    super.onClose();
    otpEditingController.dispose();
    SmsAutoFill().unregisterListener();
  }
}

class OTPVIEW extends StatelessWidget {
  const OTPVIEW({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('OTP View'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => PinFieldAutoFill(
                        textInputAction: TextInputAction.done,
                        controller: controller.otpEditingController,
                        decoration: UnderlineDecoration(
                          textStyle:
                              const TextStyle(fontSize: 16, color: Colors.blue),
                          colorBuilder: const FixedColorBuilder(
                            Colors.transparent,
                          ),
                          bgColorBuilder: FixedColorBuilder(
                            Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        currentCode: controller.messageOtpCode.value,
                        onCodeSubmitted: (code) {},
                        onCodeChanged: (code) {
                          controller.messageOtpCode.value = code!;
                          controller.countdownController.pause();
                          if (code.length == 6) {
                            // To perform some operation
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Countdown(
                      controller: controller.countdownController,
                      seconds: 15,
                      interval: const Duration(milliseconds: 1000),
                      build: (context, currentRemainingTime) {
                        if (currentRemainingTime == 0.0) {
                          return GestureDetector(
                            onTap: () {
                              // write logic here to resend OTP
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 14, bottom: 14),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border:
                                      Border.all(color: Colors.blue, width: 1),
                                  color: Colors.blue),
                              width: context.width,
                              child: const Text(
                                "Resend OTP",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 14, bottom: 14),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(color: Colors.blue, width: 1),
                            ),
                            width: context.width,
                            child: Text(
                                "Wait |${currentRemainingTime.toString().length == 4 ? " ${currentRemainingTime.toString().substring(0, 2)}" : " ${currentRemainingTime.toString().substring(0, 1)}"}",
                                style: const TextStyle(fontSize: 16)),
                          );
                        }
                      },
                    ),
                  ]),
            ),
          );
        });
  }
}
