import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:creater_management/constants/app.dart';
import 'package:creater_management/models/taskModel.dart';
import 'package:creater_management/models/walletHisModel.dart';
import 'package:creater_management/pages/taskDetailspage.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/dashBoardController.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import '../constants/widgets.dart';
import '../functions/functions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dp, _) {
      return Consumer<UserProvider>(builder: (context, up, _) {
        return Column(
          children: [
            buildHeader(dp, up),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20),
                      child: onInsta || onYoutube
                          ? Row(
                              children: [
                                if (onInsta)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/instaLogo.png',
                                        width: 30,
                                      ),
                                      const SizedBox(width: 10),
                                      h5Text(
                                        countInKMB(up
                                            .creator.data!.instaFollowers
                                            .toString()),
                                        // color: Colors.grey,
                                        fontWeight: FontWeight.bold,
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
                                      Row(
                                        children: [
                                          // h6Text(
                                          //   'Subscribers:',
                                          //   color: Colors.grey,
                                          // ),
                                          // const SizedBox(width: 10),
                                          h5Text(
                                            countInKMB(up.creator.data!
                                                .youtubeSubscribers
                                                .toString()),
                                            // color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     const Icon(
                                //       Icons.circle,
                                //       color: Colors.red,
                                //       size: 15,
                                //     ),
                                //     const SizedBox(width: 5),
                                //     b1Text(
                                //       'Live Count',
                                //       color: Colors.red,
                                //     ),
                                //   ],
                                // )
                              ],
                            )
                          : Row(
                              children: [
                                b1Text(
                                    'You have not any subscriber or follower',
                                    overflow: TextOverflow.ellipsis,
                                    maxLine: 2),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: h4Text(
                                                dp.userTasksHistory.total_collab
                                                    .toString(),
                                                color: Colors.grey,
                                                textAlign: TextAlign.center,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: h6Text('Total Collab',
                                                textAlign: TextAlign.center,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                    width: 1, thickness: 1, color: Colors.grey),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: h4Text(
                                                dp.userTasksHistory.pending_task
                                                    .toString(),
                                                color: Colors.grey,
                                                textAlign: TextAlign.center,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: h6Text('Pending Tasks',
                                                textAlign: TextAlign.center,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                              height: 0, thickness: 1, color: Colors.grey),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: h4Text(
                                                dp.userTasksHistory
                                                    .completed_collab
                                                    .toString(),
                                                color: Colors.grey,
                                                textAlign: TextAlign.center,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: h6Text('Completed Collab',
                                                textAlign: TextAlign.center,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                    width: 1, thickness: 1, color: Colors.grey),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: h4Text(
                                                dp.userTasksHistory
                                                    .rajected_collab
                                                    .toString(),
                                                color: Colors.grey,
                                                textAlign: TextAlign.center,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: h6Text('Rejected Collab',
                                                textAlign: TextAlign.center,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // child: SingleChildScrollView(
                      //   child: Column(
                      //     children: [
                      //       // Row(
                      //       //   children: [
                      //       //     Expanded(
                      //       //         child: TextFormField(
                      //       //       readOnly: true,
                      //       //       controller: up.firstNameController,
                      //       //       cursorHeight: 25,
                      //       //       keyboardType: TextInputType.text,
                      //       //       // cursorColor: Colors.white,
                      //       //       style: const TextStyle(
                      //       //         fontWeight: FontWeight.normal,
                      //       //         // color: Colors.white,
                      //       //         fontSize: 20,
                      //       //       ),
                      //       //       onChanged: (val) {
                      //       //         // if (val.length > 10) {
                      //       //         //   setState(() {
                      //       //         //     ap.phoneController.text =
                      //       //         //         val.substring(0, 10);
                      //       //         //   });
                      //       //         // }
                      //       //         // if (val.length == 10) {
                      //       //         //   FocusManager.instance.primaryFocus?.unfocus();
                      //       //         // }
                      //       //       },
                      //       //       decoration: InputDecoration(
                      //       //         hintText: 'First Name',
                      //       //         hintStyle: const TextStyle(
                      //       //           fontWeight: FontWeight.normal,
                      //       //           color: Colors.grey,
                      //       //           fontSize: 20,
                      //       //         ),
                      //       //         border: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         enabledBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         focusedBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //       ),
                      //       //     ))
                      //       //   ],
                      //       // ),
                      //       // const SizedBox(height: 15),
                      //       // Row(
                      //       //   children: [
                      //       //     Expanded(
                      //       //         child: TextFormField(
                      //       //       readOnly: true,
                      //       //
                      //       //       controller: up.lastNameController,
                      //       //       cursorHeight: 25,
                      //       //       keyboardType: TextInputType.text,
                      //       //       // cursorColor: Colors.white,
                      //       //       style: const TextStyle(
                      //       //         fontWeight: FontWeight.normal,
                      //       //         // color: Colors.white,
                      //       //         fontSize: 20,
                      //       //       ),
                      //       //       onChanged: (val) {
                      //       //         // if (val.length > 10) {
                      //       //         //   setState(() {
                      //       //         //     ap.phoneController.text =
                      //       //         //         val.substring(0, 10);
                      //       //         //   });
                      //       //         // }
                      //       //         // if (val.length == 10) {
                      //       //         //   FocusManager.instance.primaryFocus?.unfocus();
                      //       //         // }
                      //       //       },
                      //       //       decoration: InputDecoration(
                      //       //         hintText: 'Last Name',
                      //       //         hintStyle: const TextStyle(
                      //       //           fontWeight: FontWeight.normal,
                      //       //           color: Colors.grey,
                      //       //           fontSize: 20,
                      //       //         ),
                      //       //         border: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         enabledBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         focusedBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //       ),
                      //       //     ))
                      //       //   ],
                      //       // ),
                      //       // const SizedBox(height: 15),
                      //       Row(
                      //         children: [
                      //           Expanded(
                      //               child: TextFormField(
                      //             controller: up.emailController,
                      //             // readOnly: true,
                      //
                      //             cursorHeight: 25,
                      //             keyboardType: TextInputType.emailAddress,
                      //             // cursorColor: Colors.white,
                      //             style: const TextStyle(
                      //               fontWeight: FontWeight.normal,
                      //               // color: Colors.white,
                      //               fontSize: 20,
                      //             ),
                      //             onChanged: (val) {
                      //               // if (val.length > 10) {
                      //               //   setState(() {
                      //               //     ap.phoneController.text =
                      //               //         val.substring(0, 10);
                      //               //   });
                      //               // }
                      //               // if (val.length == 10) {
                      //               //   FocusManager.instance.primaryFocus?.unfocus();
                      //               // }
                      //             },
                      //             decoration: InputDecoration(
                      //               hintText: 'Email Address',
                      //               hintStyle: const TextStyle(
                      //                 fontWeight: FontWeight.normal,
                      //                 color: Colors.grey,
                      //                 fontSize: 20,
                      //               ),
                      //               border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(15),
                      //                 borderSide: const BorderSide(
                      //                   color: Colors.grey,
                      //                 ),
                      //               ),
                      //               enabledBorder: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(15),
                      //                 borderSide: const BorderSide(
                      //                   color: Colors.grey,
                      //                 ),
                      //               ),
                      //               focusedBorder: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(15),
                      //                 borderSide: const BorderSide(
                      //                   color: Colors.grey,
                      //                 ),
                      //               ),
                      //             ),
                      //           ))
                      //         ],
                      //       ),
                      //       const SizedBox(height: 15),
                      //       // Row(
                      //       //   children: [
                      //       //     Expanded(
                      //       //         child: TextFormField(
                      //       //       readOnly: true,
                      //       //       controller: up.phoneController,
                      //       //       cursorHeight: 25,
                      //       //       keyboardType: TextInputType.phone,
                      //       //       // cursorColor: Colors.white,
                      //       //       style: const TextStyle(
                      //       //         fontWeight: FontWeight.normal,
                      //       //         // color: Colors.white,
                      //       //         fontSize: 20,
                      //       //       ),
                      //       //       onChanged: (val) {
                      //       //         // if (val.length > 10) {
                      //       //         //   setState(() {
                      //       //         //     ap.phoneController.text =
                      //       //         //         val.substring(0, 10);
                      //       //         //   });
                      //       //         // }
                      //       //         // if (val.length == 10) {
                      //       //         //   FocusManager.instance.primaryFocus?.unfocus();
                      //       //         // }
                      //       //       },
                      //       //       decoration: InputDecoration(
                      //       //         hintText: 'Mobile No.',
                      //       //         hintStyle: const TextStyle(
                      //       //           fontWeight: FontWeight.normal,
                      //       //           color: Colors.grey,
                      //       //           fontSize: 20,
                      //       //         ),
                      //       //         border: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         enabledBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         focusedBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //       ),
                      //       //     ))
                      //       //   ],
                      //       // ),
                      //       // const SizedBox(height: 15),
                      //       Row(
                      //         children: [
                      //           Expanded(
                      //               child: TextFormField(
                      //             // readOnly: true,
                      //
                      //             controller: up.addressController,
                      //             cursorHeight: 25,
                      //             keyboardType: TextInputType.emailAddress,
                      //             // cursorColor: Colors.white,
                      //             style: const TextStyle(
                      //               fontWeight: FontWeight.normal,
                      //               // color: Colors.white,
                      //               fontSize: 20,
                      //             ),
                      //             onChanged: (val) {
                      //               // if (val.length > 10) {
                      //               //   setState(() {
                      //               //     ap.phoneController.text =
                      //               //         val.substring(0, 10);
                      //               //   });
                      //               // }
                      //               // if (val.length == 10) {
                      //               //   FocusManager.instance.primaryFocus?.unfocus();
                      //               // }
                      //             },
                      //             maxLines: 2,
                      //             decoration: InputDecoration(
                      //               hintText: 'Address',
                      //               hintStyle: const TextStyle(
                      //                 fontWeight: FontWeight.normal,
                      //                 color: Colors.grey,
                      //                 fontSize: 20,
                      //               ),
                      //               border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(15),
                      //                 borderSide: const BorderSide(
                      //                   color: Colors.grey,
                      //                 ),
                      //               ),
                      //               enabledBorder: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(15),
                      //                 borderSide: const BorderSide(
                      //                   color: Colors.grey,
                      //                 ),
                      //               ),
                      //               focusedBorder: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(15),
                      //                 borderSide: const BorderSide(
                      //                   color: Colors.grey,
                      //                 ),
                      //               ),
                      //             ),
                      //           ))
                      //         ],
                      //       ),
                      //       // const SizedBox(height: 15),
                      //       // Row(
                      //       //   children: [
                      //       //     Expanded(
                      //       //         child: TextFormField(
                      //       //       controller: up.instaFollowersController,
                      //       //       // readOnly: true,
                      //       //
                      //       //       cursorHeight: 25,
                      //       //       keyboardType: TextInputType.number,
                      //       //       // cursorColor: Colors.white,
                      //       //       style: const TextStyle(
                      //       //         fontWeight: FontWeight.normal,
                      //       //         // color: Colors.white,
                      //       //         fontSize: 20,
                      //       //       ),
                      //       //       onChanged: (val) {
                      //       //         // if (val.length > 10) {
                      //       //         //   setState(() {
                      //       //         //     ap.phoneController.text =
                      //       //         //         val.substring(0, 10);
                      //       //         //   });
                      //       //         // }
                      //       //         // if (val.length == 10) {
                      //       //         //   FocusManager.instance.primaryFocus?.unfocus();
                      //       //         // }
                      //       //       },
                      //       //       decoration: InputDecoration(
                      //       //         hintText: 'Instagram Followers',
                      //       //         labelText: 'Instagram Followers',
                      //       //         hintStyle: const TextStyle(
                      //       //           fontWeight: FontWeight.normal,
                      //       //           color: Colors.grey,
                      //       //           fontSize: 20,
                      //       //         ),
                      //       //         border: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         enabledBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         focusedBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //       ),
                      //       //     ))
                      //       //   ],
                      //       // ),
                      //       // const SizedBox(height: 15),
                      //       // Row(
                      //       //   children: [
                      //       //     Expanded(
                      //       //         child: TextFormField(
                      //       //       controller: up.ytSubscribersController,
                      //       //       readOnly: true,
                      //       //
                      //       //       cursorHeight: 25,
                      //       //       keyboardType: TextInputType.number,
                      //       //       // cursorColor: Colors.white,
                      //       //       style: const TextStyle(
                      //       //         fontWeight: FontWeight.normal,
                      //       //         // color: Colors.white,
                      //       //         fontSize: 20,
                      //       //       ),
                      //       //       onChanged: (val) {
                      //       //         // if (val.length > 10) {
                      //       //         //   setState(() {
                      //       //         //     ap.phoneController.text =
                      //       //         //         val.substring(0, 10);
                      //       //         //   });
                      //       //         // }
                      //       //         // if (val.length == 10) {
                      //       //         //   FocusManager.instance.primaryFocus?.unfocus();
                      //       //         // }
                      //       //       },
                      //       //       decoration: InputDecoration(
                      //       //         hintText: 'Youtube Subscribers',
                      //       //         labelText: 'Youtube Subscribers',
                      //       //         hintStyle: const TextStyle(
                      //       //           fontWeight: FontWeight.normal,
                      //       //           color: Colors.grey,
                      //       //           fontSize: 20,
                      //       //         ),
                      //       //         border: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         enabledBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //         focusedBorder: OutlineInputBorder(
                      //       //           borderRadius: BorderRadius.circular(15),
                      //       //           borderSide: const BorderSide(
                      //       //             color: Colors.grey,
                      //       //           ),
                      //       //         ),
                      //       //       ),
                      //       //     ))
                      //       //   ],
                      //       // ),
                      //       const SizedBox(height: 15),
                      //       const SizedBox(height: 20),
                      //     ],
                      //   ),
                      // ),
                    ),
                    // bottomNavigationBar: Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 8.0, vertical: 5),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: ListTile(
                    //           tileColor: App.themecolor,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(15),
                    //           ),
                    //           onTap: () async {
                    //             if (up.creator.data!.status == 'Active') {
                    //               await up.updateProfile(homePage: false);
                    //             } else {
                    //               showNotVerifiedDialog(
                    //                   up.creator.data!.status == 'Active',
                    //                   false);
                    //             }
                    //           },
                    //           title: h6Text(
                    //             'Update ',
                    //             textAlign: TextAlign.center,
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
          ],
        );
      });
    });
  }

  Widget buildHeader(DashboardProvider dp, UserProvider up) {
    return Stack(
      children: [
        Container(height: 300),
        ClipPath(
          clipper: DiagonalPathClipperOne(),
          child: Container(
            height: 250,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  App.themecolor,
                  App.themecolor1,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        dp.scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              width: 45,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              width: 35,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              width: 45,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          // left: 20,
          // right: 20,
          child: SizedBox(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await up.updateImage(true);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: up.creator.data!.profilePic != null &&
                            up.creator.data!.profilePic != ''
                        ? FileImage(File(
                            '$appTempPath/${up.creator.data!.profilePic!.split('/').last}'))
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                    child: up.uploadingImage
                        ? Center(
                            child: LoadingBouncingGrid.square(
                              borderColor: Get.theme.colorScheme.primary,
                              borderSize: 3.0,
                              size: 30.0,
                              inverted: false,
                              backgroundColor: Colors.white,
                              duration: const Duration(milliseconds: 2000),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    h6Text(
                      (up.creator.data!.fullName ?? 'Your Name'),
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 10),
                    if (up.creator.data!.status == 'Active')
                      SizedBox(
                        width: up.creator.data!.status != 'Active' ? 18 : 25,
                        child: Image.asset(
                          'assets/images/${up.creator.data!.status != 'Active' ? 'not-' : ''}verified.png',
                          color: up.creator.data!.status != 'Active'
                              ? Colors.red
                              : null,
                        ),
                      ),
                  ],
                ),
                if (up.creator.data!.status != 'Active')
                  b1Text(
                    'Unverified',

                    // color: Colors.green,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
