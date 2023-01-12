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
import '../functions/functions.dart';

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
                            setState(() {

                            });
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 20, bottom: 20),
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
                                height: 50,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // height: 20,

                                      margin:
                                          const EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                        // shape: BoxShape.circle,
                                        borderRadius: BorderRadius.circular(100),
                                        color: ap.phoneController.text.isEmpty?Colors.transparent:Colors.grey[400],
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: Center(
                                          child: h6Text(
                                        'Login',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )),
                                      // child: const Icon(
                                      //   Icons.arrow_forward_ios_outlined,
                                      //   color: Colors.white,
                                      // ),
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
                                h6Text(
                                  'Partnership',
                                  color: Colors.white54,
                                ),
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

class _OtpScreenState extends State<OtpScreen> {
  final scaffoldKey = GlobalKey();
  // late OTPTextEditController controller;
  // late OTPInteractor _otpInteractor;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, ap, _) {
      return Scaffold(
        backgroundColor: App.themecolor,
        body: Stack(
          children: [
            SizedBox(
              height: Get.height,
              width: Get.width,
            ),
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
                    Row(
                      children: [
                        Expanded(
                          child: h5Text(
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
                      children: [
                        Expanded(
                          child: OTPTextField(
                            controller: ap.otpFieldController,
                            length: 4,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 35,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white),
                            otpFieldStyle: OtpFieldStyle(
                              errorBorderColor: Colors.yellow,
                              focusBorderColor: Colors.white,
                              enabledBorderColor: Colors.white,
                              borderColor: Colors.white,
                            ),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) async {
                              print("Completed: $pin ${ap.resOtp}");
                              if (ap.resOtp == pin) {
                                hoverBlankLoadingDialog(true);
                                ap.otpController.clear();
                                ap.otpFieldController.clear();

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
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.03),
                    Row(
                      children: [
                        Expanded(
                          child: h6Text(
                            'Enter four digit OTP',
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
                            ap.otpFieldController.clear();
                            ap.otpController.clear();
                            await ap.sendOtpApi(ap.phoneController.text,
                                otpScreen: true);
                          },
                          child: b1Text(
                            ap.otpTimeOutDuration == 0
                                ? 'Resend OTP ${ap.otpTimeOutDuration}'
                                : timerString(ap.otpTimeOutDuration),
                            color: Colors.white,
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
                                h6Text(
                                  'Partnership',
                                  color: Colors.white54,
                                ),
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
