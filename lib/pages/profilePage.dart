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
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 20),
                      child: onInsta || onYoutube
                          ? Row(
                              children: [
                                if (onInsta)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/instaLogo.png',
                                        height: 25,
                                      ),
                                      const SizedBox(width: 10),
                                      h6Text(
                                        countInKMB(up
                                            .creator.data!.instaFollowers
                                            .toString()),
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
                                        width: 35,
                                        height: 25,
                                        fit: BoxFit.fill,
                                        color: const Color(0xFFD50606),
                                      ),
                                      const SizedBox(width: 10),
                                      Row(
                                        children: [
                                          h6Text(
                                            countInKMB(up.creator.data!
                                                .youtubeSubscribers
                                                .toString()),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'You have not any subscriber or follower',
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
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
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: h3Text(
                                              dp.userTasksHistory.total_collab
                                                  .toString(),
                                              color: Colors.grey[600],
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text('Total Collab',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontWeight:
                                                      FontWeight.normal)),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: h3Text(
                                              dp.userTasksHistory.pending_task
                                                  .toString(),
                                              color: Colors.grey[600],
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text('Pending Tasks',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontWeight:
                                                      FontWeight.normal)),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: h3Text(
                                              dp.userTasksHistory
                                                  .completed_collab
                                                  .toString(),
                                              color: Colors.grey[600],
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text('Completed Collab',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontWeight:
                                                      FontWeight.normal)),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: h3Text(
                                              dp.userTasksHistory
                                                  .rajected_collab
                                                  .toString(),
                                              color: Colors.grey[600],
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Rejected Collab',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.normal),
                                          ),
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
            const SizedBox(height: 15),
          ],
        );
      });
    });
  }

  Widget buildHeader(DashboardProvider dp, UserProvider up) => Stack(
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
                      radius: 60,
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
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (up.creator.data!.fullName ?? 'Your Name'),
                        textAlign: TextAlign.center,
                        // fontWeight: FontWeight.bold,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.grey[700]),
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
                    Text(
                      'Unverified',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.normal),
                      // color: Colors.green,
                    ),
                ],
              ),
            ),
          ),
        ],
      );
}
