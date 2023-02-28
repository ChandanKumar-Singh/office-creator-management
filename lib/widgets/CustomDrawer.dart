import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:creater_management/constants/app.dart';
import 'package:creater_management/constants/widgets.dart';
import 'package:creater_management/models/createrModel.dart';
import 'package:creater_management/pages/completeProfile.dart';
import 'package:creater_management/providers/dashBoardController.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/functions.dart';
import '../providers/authProvider.dart';
import 'instatesting.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.75,
      child: Drawer(
        // backgroundColor: App.themecolor1,
        child: Consumer<UserProvider>(builder: (context, up, _) {
          // print('is on yt : $onYoutube');
          // print('is on insta : $onInsta');
          return Consumer<DashboardProvider>(builder: (context, dp, _) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: up.creator.data!.profilePic !=
                                          null &&
                                      up.creator.data!.profilePic != ''
                                  ? FileImage(File(
                                      '$appTempPath/${up.creator.data!.profilePic!.split('/').last}'))
                                  : const AssetImage('assets/images/user.png')
                                      as ImageProvider,
                            ),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10),
                                  child: Column(
                                    children: [
                                      h6Text(
                                          up.creator.data!.fullName ??
                                              'Your Name',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]),
                                      const SizedBox(height: 7),
                                      Row(children: [
                                        if (onInsta)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/instaLogo.png',
                                                height: 13,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                countInKMB(up.creator.data!
                                                    .instaFollowers
                                                    .toString()),
                                                // countInKMB(9374393
                                                //     .toString()),
                                                overflow: TextOverflow.ellipsis,
                                                // color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        if (onYoutube && onInsta)
                                          const Spacer(),
                                        if (onYoutube)
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/youtubeLogo.jpg',
                                                height: 13,
                                                color: const Color(0xFFD50606),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                countInKMB(
                                                    4877747343.toString()),
                                                // countInKMB(up.creator.data!
                                                //     .youtubeSubscribers
                                                //     .toString()),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                      ]),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                    const CompleteProfilePage(fromInside:true));
                                              },
                                              child: const Text(
                                                'Edit Profile',
                                                style: TextStyle(
                                                  color: App.themecolor,
                                                  height: 1.5,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      thickness: 2,
                      height: 0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            // tileColor: Colors.white54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onTap: () async {
                              generateMyLink(up.creator);
                              // Fluttertoast.showToast(msg: 'Coming soon!');
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: h6Text(
                                    '-Generate my link',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                            // leading: const Icon(
                            //   Icons.logout,
                            //   color: Colors.red,
                            //   size: 32,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            tileColor: Colors.white54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // onTap: () async {
                            //   bool? canCall = await callNumber(
                            //       up.creator.call_relationship_manager ?? '');
                            //   if (canCall != null && !canCall) {
                            //     Fluttertoast.showToast(
                            //         msg: 'Can\'t call on this number');
                            //   }
                            // },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: h6Text(
                                    '-Call Relationship Manager',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // leading: const Icon(
                            //   Icons.logout,
                            //   color: Colors.red,
                            //   size: 32,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            // tileColor: Colors.white54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onTap: () async {
                              AwesomeDialog(
                                dialogType: DialogType.question,
                                title: '\nAre you sure to log out?',
                                context: context,
                                btnOkOnPress: () async {
                                  await Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .logOut();
                                },
                                btnCancelOnPress: () {},
                              ).show();
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                h5Text(
                                  'Logout',
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                            // leading: const Icon(
                            //   Icons.logout,
                            //   color: Colors.red,
                            //   size: 32,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          });
        }),
      ),
    );
  }

  void generateMyLink(Creator creator) async {
    hoverBlankLoadingDialog(true, true);
    await Clipboard.setData(ClipboardData(
            text: 'https://techkaro.in/creator.php?id=${creator.data!.id}'))
        .then((value) async => await Future.delayed(const Duration(seconds: 3))
                .then((value) async {
              Fluttertoast.showToast(
                  msg: 'You successfully copied your collaboration link.',
                  backgroundColor: App.themecolor);
            }));
    hoverBlankLoadingDialog(false);
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.moveTo(0, size.width);
    path.moveTo(size.width, size.height);
    path.moveTo(size.width, size.height - 100);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
