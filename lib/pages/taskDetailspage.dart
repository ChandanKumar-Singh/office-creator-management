import 'dart:developer';

import 'package:creater_management/constants/app.dart';
import 'package:creater_management/pages/homePage.dart';
import 'package:creater_management/pages/uploadProofPage.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/dashBoardController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/widgets.dart';
import '../functions/functions.dart';
import '../models/taskModel.dart';
import '../widgets/CustomDrawer.dart';
import '../widgets/buildCacheImageNetwork.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage(
      {Key? key,
      this.task,
      this.response,
      this.heroTag,
      this.status,
      this.reason})
      : super(key: key);
  final TaskModel? task;
  final int? response;
  final String? heroTag;
  final String? reason;
  final int? status;
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int selectedBottomIndex = 0;
  late final TaskModel task;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.task != null) {
      task = widget.task!;
    }
  }

  ScrollController deliverablesCtrl = ScrollController();
  ScrollController termsConditionCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    print(widget.status);
    return Scaffold(
        key: _scaffoldKey,
        // backgroundColor: Get.theme.scaffoldBackgroundColor.withOpacity(0.8),
        // drawer: const CustomDrawer(),
        bottomNavigationBar: widget.response != null && widget.response == 0
            ? TaskDetailsAcceptRejectButtons(
                taskId: task.id!,
              )
            : widget.status == 0 || widget.status == 3 || widget.status == 1
                ? TaskDetailsUploadDocsButtons(
                    task: task, reason: widget.reason, status: widget.status)
                : const SizedBox.shrink(),
        body: Container(
          color: Get.theme.scaffoldBackgroundColor.withOpacity(0.7),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                  ),
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
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: const Center(
                                      child: Icon(Icons.arrow_back_rounded,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     _scaffoldKey.currentState?.openDrawer();
                                //   },
                                //   child: Container(
                                //     color: Colors.transparent,
                                //     child: Column(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.start,
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         Container(
                                //           height: 3,
                                //           decoration: BoxDecoration(
                                //             borderRadius:
                                //                 BorderRadius.circular(10),
                                //             color: Colors.white,
                                //           ),
                                //           width: 45,
                                //         ),
                                //         const SizedBox(height: 10),
                                //         Container(
                                //           height: 3,
                                //           decoration: BoxDecoration(
                                //             borderRadius:
                                //                 BorderRadius.circular(10),
                                //             color: Colors.white,
                                //           ),
                                //           width: 35,
                                //         ),
                                //         const SizedBox(height: 10),
                                //         Container(
                                //           height: 3,
                                //           decoration: BoxDecoration(
                                //             borderRadius:
                                //                 BorderRadius.circular(10),
                                //             color: Colors.white,
                                //           ),
                                //           width: 45,
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: h5Text(
                                    task.title ?? '',
                                    height: 1,
                                    textAlign: TextAlign.center,
                                    color: Colors.white,
                                    maxLine: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.response == 0)
                          Hero(
                            tag: widget.heroTag ?? task.title!,
                            child: isOnline
                                ? SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: buildCachedNetworkImage(
                                          imageUrl: App.imageBase +
                                              (task.image ?? '')),
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/noInternet.png',
                                    width: 100,
                                  ),
                          ),
                        if (widget.response == 1)
                          Hero(
                            tag: widget.heroTag ?? task.title!,
                            child: isOnline
                                ? SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: buildCachedNetworkImage(
                                          imageUrl: App.imageBase +
                                              (task.image ?? '')),
                                    ),
                                  )
                                : Image.asset('assets/images/noInternet.png',
                                    width: 100),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: h6Text(task.mainTitle ?? ' ',
                                  maxLine: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Payment ${NumberFormat.simpleCurrency(name: '₹ ').format(double.parse(task.amount ?? '0'))}',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: Consumer<DashboardProvider>(builder: (context, dp, _) {
                    return dp.loadingTasks
                        ? buildTaskDetailsSkeleton()
                        : Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.all(0),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              // height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // color: Colors.grey
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      h6Text('Deliverables',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]),
                                    ],
                                  ),
                                  Expanded(
                                    child: Scrollbar(
                                      controller: deliverablesCtrl,
                                      // thumbVisibility: true,
                                      thickness: 10,
                                      radius: const Radius.circular(10),
                                      trackVisibility: true,
                                      child: ListView(
                                        controller: deliverablesCtrl,
                                        padding: const EdgeInsets.all(0),
                                        children: [
                                          SelectableLinkify(
                                            onOpen: (link) async {
                                              var url = link.url;
                                              if (await canLaunchUrl(
                                                  Uri.parse(url))) {
                                                try {
                                                  await launchUrl(
                                                      Uri.parse(url),
                                                      mode: LaunchMode
                                                          .externalApplication);
                                                } catch (e) {
                                                  log(e.toString());
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Could not open the url');
                                                throw 'Could not launch $link';
                                              }
                                            },
                                            text: task.description ?? '',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 13,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      h6Text(
                                        'Terms & Conditions',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Scrollbar(
                                      controller: termsConditionCtrl,
                                      // thumbVisibility: true,
                                      thickness: 10,
                                      radius: const Radius.circular(10),
                                      trackVisibility: true,
                                      child: ListView(
                                        controller: termsConditionCtrl,
                                        padding: const EdgeInsets.all(0),
                                        children: [
                                          SelectableLinkify(
                                            onOpen: (link) async {
                                              var url = link.url;
                                              if (await canLaunchUrl(
                                                  Uri.parse(url))) {
                                                try {
                                                  await launchUrl(
                                                      Uri.parse(url),
                                                      mode: LaunchMode
                                                          .externalApplication);
                                                } catch (e) {
                                                  log(e.toString());
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Could not open the url');
                                                throw 'Could not launch $link';
                                              }
                                            },
                                            text: task.termsConditions ?? '',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 13,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  }),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildTaskDetailsSkeleton() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(0),
      child: Container(
        padding: const EdgeInsets.all(10),
        // height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                h6Text(
                  'Deliverables',
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 7),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Skeleton(height: 10, width: 50, style: SkeletonStyle.text),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Row(
              children: [
                h6Text(
                  'Terms & Conditions',
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 7),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Skeleton(height: 10, style: SkeletonStyle.text)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Skeleton(height: 10, width: 150, style: SkeletonStyle.text),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class TaskDetailsAcceptRejectButtons extends StatelessWidget {
  const TaskDetailsAcceptRejectButtons({
    Key? key,
    required this.taskId,
  }) : super(key: key);
  final int taskId;

  @override
  Widget build(BuildContext context) {
    var dp = Provider.of<DashboardProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                var res = await dp.userAcceptOrReject(taskId, 0);
                if (res != 0) {
                  dp.setBottomIndex(1);
                  Get.back();
                  dp.getResTasks();
                  dp.getTasks();
                  dp.getUserTasksHistory();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: App.themecolor.withOpacity(0.7),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'REJECT',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                var res = await dp.userAcceptOrReject(taskId, 1);
                if (res != 0) {
                  dp.setBottomIndex(1);

                  Get.back();
                  dp.getResTasks();
                  dp.getTasks();
                  dp.getUserTasksHistory();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'ACCEPT',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class TaskDetailsUploadDocsButtons extends StatelessWidget {
  const TaskDetailsUploadDocsButtons({
    Key? key,
    required this.task,
    this.reason,
    this.status,
  }) : super(key: key);

  final TaskModel task;
  final String? reason;
  final int? status;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: App.themecolor.withOpacity(0.8),
              // ),
              onTap: status == 1
                  ? null
                  : () async {
                      Navigator.push(
                          Get.context!,
                          slideLeftRoute(
                            UploadProofPage(
                              task: task,
                              reason: reason,
                            ),
                            effect: PageTransitionType.rightToLeftJoined,
                            current: TaskDetailsPage(
                              task: task,
                            ),
                          ));
                    },
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // color: App.themecolor,
                    border: Border.all(
                      color:  status == 1
                          ?Colors.grey[300]!:Colors.grey,
                      width: 0.8,
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (status == 1)
                      Image.asset(
                        'assets/images/time_loading_no_bg.gif',
                        fit: BoxFit.cover,
                        height: 23,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            status != 1
                                ? 'UPLOAD PROOF OF WORK'
                                : 'Under Moderate*',
                            style: TextStyle(
                                fontWeight: status != 1
                                    ? FontWeight.bold
                                    : FontWeight.w300,
                                fontSize: status != 1
                                    ? Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .fontSize
                                    : 9,
                                color: App.themecolor,
                                height: status != 1 ? 1.5 : 1.0))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expanded(
          //   child: OutlinedButton(
          //     style: ElevatedButton.styleFrom(
          //         // backgroundColor: App.yellowButtonColor,
          //         // backgroundColor: Colors.black,
          //         side: const BorderSide(color: Colors.black)),
          //     onPressed: () {
          //       Navigator.push(
          //           Get.context!,
          //           slideLeftRoute(
          //               UploadProofPage(
          //                 task: task,
          //                 reason: reason,
          //               ),
          //               effect: PageTransitionType.rightToLeftJoined,
          //               current: TaskDetailsPage(
          //                 task: task,
          //               )));
          //     },
          //     child: h6Text(
          //       'UPLOAD PROOF OF WORK',
          //       style: const TextStyle(
          //         letterSpacing: 0,
          //         fontSize: 22,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
