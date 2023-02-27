import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:creater_management/constants/app.dart';
import 'package:creater_management/constants/widgets.dart';
import 'package:creater_management/pages/completeProfile.dart';
import 'package:creater_management/providers/dashBoardController.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:flutter/material.dart';
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
    return Container(
      width: Get.width*0.75,
      child: Drawer(
        // backgroundColor: App.themecolor1,
        child: Consumer<UserProvider>(builder: (context, up, _) {
          print('is on yt : $onYoutube');
          print('is on insta : $onInsta');
          return Consumer<DashboardProvider>(builder: (context, dp, _) {
            return SafeArea(
              child: Container(
                // width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
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
                                        vertical: 15.0, horizontal: 20),
                                    child: Wrap(
                                      children: [
                                        h5Text(
                                          up.creator.data!.fullName ??
                                              'Your Name',
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                          color: Colors.grey,
                                        ),
                                        if (onInsta)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/instaLogo.png',
                                                width: 30,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: h5Text(
                                                  countInKMB(up.creator.data!
                                                      .instaFollowers
                                                      .toString()),
                                                  // countInKMB(93743497346893
                                                  //     .toString()),
                                                  overflow: TextOverflow.ellipsis,
                                                  // color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (onYoutube && onInsta)
                                          const SizedBox(width: 20),
                                        if (onYoutube)
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/youtubeLogo.jpg',
                                                width: 30,
                                                height: 40,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: h5Text(
                                                  // countInKMB(487763546747343
                                                  //     .toString()),
                                                  countInKMB(up.creator.data!
                                                      .youtubeSubscribers
                                                      .toString()),
                                                  // // color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        TextButton(
                                            onPressed: () {
                                              Get.to(const CompleteProfilePage());
                                            },
                                            child: b1Text(
                                              'Edit Profile',
                                              style: const TextStyle(
                                                color: App.themecolor,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ))
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          // h5Text(
                          //   up.creator.data!.fullName ?? 'Your Name',
                          //   fontWeight: FontWeight.bold,
                          //   color: Colors.white,
                          // ),
                          // b1Text(
                          //   up.creator.data!.phone ?? 'Your Mobile No.',
                          //   color: Colors.white,
                          // ),
                        ],
                      ),
                    ),
                    const Divider(),


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
                              onTap: () async {
                                Fluttertoast.showToast(msg: 'Coming soon!');
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


                    // if (onInsta)
                    //   Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //         child: Card(
                    //           elevation: 7,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(15),
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(15.0),
                    //             child: Column(
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     Image.asset(
                    //                       'assets/images/instaLogo.png',
                    //                       width: 50,
                    //                       height: 40,
                    //                     ),
                    //                     const SizedBox(width: 10),
                    //                     Expanded(
                    //                       child: RichText(
                    //                         text: TextSpan(
                    //                           text: 'Followers: ',
                    //                           style: const TextStyle(
                    //                             color: Colors.grey,
                    //                             fontSize: 20,
                    //                             fontWeight: FontWeight.bold,
                    //                           ),
                    //                           children: [
                    //                             TextSpan(
                    //                               text: up
                    //                                   .creator.data!.instaFollowers!
                    //                                   .toString(),
                    //                               style: const TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(height: 10),
                    //     ],
                    //   ),
                    // if (onYoutube)
                    //   Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //         child: Card(
                    //           elevation: 7,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(15),
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(15.0),
                    //             child: Column(
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     Image.asset(
                    //                       'assets/images/youtubeLogo.jpg',
                    //                       width: 50,
                    //                     ),
                    //                     const SizedBox(width: 10),
                    //                     Expanded(
                    //                       child: RichText(
                    //                         text: TextSpan(
                    //                           text: 'Subscribers: ',
                    //                           style: const TextStyle(
                    //                             color: Colors.grey,
                    //                             fontSize: 20,
                    //                             fontWeight: FontWeight.bold,
                    //                           ),
                    //                           children: [
                    //                             TextSpan(
                    //                               text: up.creator.data!
                    //                                   .youtubeSubscribers!
                    //                                   .toString(),
                    //                               style: const TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(height: 10),
                    //     ],
                    //   ),
                    // const Spacer(),

                    const Spacer(),
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.help,
                    //     color: Colors.white,
                    //   ),
                    //   title: h6Text(
                    //     'Help',
                    //     color: Colors.white,
                    //   ),
                    //   onTap: () {},
                    // ),
                    // const SizedBox(height: 10),
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.support_agent_outlined,
                    //     color: Colors.white,
                    //   ),
                    //   title: h6Text(
                    //     'Support',
                    //     color: Colors.white,
                    //   ),
                    //   onTap: () async {
                    //     if (await canLaunchUrl(Uri.parse(
                    //         'https://www.youtube.com/watch?v=y2tEPmwWEiI&list=RDy2tEPmwWEiI&start_radio=1&ab_channel=ThraceMusic'))) {
                    //       await launchUrl(Uri.parse(
                    //           'https://www.youtube.com/watch?v=y2tEPmwWEiI&list=RDy2tEPmwWEiI&start_radio=1&ab_channel=ThraceMusic'));
                    //     }
                    //   },
                    // ),
                    // const SizedBox(height: 10),
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.web_stories,
                    //     color: Colors.white,
                    //   ),
                    //   title: h6Text(
                    //     'About',
                    //     color: Colors.white,
                    //   ),
                    //   onTap: () {
                    //     // Get.to(CompleteProfilePage());
                    //   },
                    // ),
                    // const SizedBox(height: 10),
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
                                    'Log Out',
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
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
              ),
            );
          });
        }),
      ),
    );
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
