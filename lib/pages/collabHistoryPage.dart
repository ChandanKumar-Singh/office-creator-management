import 'dart:async';

import 'package:creater_management/constants/app.dart';
import 'package:creater_management/models/taskModel.dart';
import 'package:creater_management/pages/taskDetailspage.dart';
import 'package:creater_management/pages/walletPage.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/dashBoardController.dart';
import 'package:creater_management/widgets/buildCacheImageNetwork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import '../constants/widgets.dart';
import '../functions/functions.dart';
import '../widgets/taskSckeleton.dart';
import 'homePage.dart';

class CollabHistoryPage extends StatefulWidget {
  const CollabHistoryPage({Key? key}) : super(key: key);

  @override
  State<CollabHistoryPage> createState() => _CollabHistoryPageState();
}

class _CollabHistoryPageState extends State<CollabHistoryPage> {
  List<String> bottomList = ['mycollab', 'history', 'wallet', 'myprofile'];

  ///Refreshing
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  Future<void> _refresh() async {
    var dp = Provider.of<DashboardProvider>(context, listen: false);
    await dp
        .getResTasks()
        .then((value) => _controller.sink.add(SwipeRefreshState.hidden));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dp, _) {
      return Column(
        children: [
          buildHeader(dp),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),

              child: !dp.loadingResTasks && dp.resTasks.isEmpty
                  ? buildNoHistory('No collaboration')
                  : buildSwipeRefresh(dp),

            ),
          ),
        ],
      );
    });
  }

  SwipeRefresh buildSwipeRefresh(DashboardProvider dp) {
    return SwipeRefresh.builder(
      stateStream: _stream,
      onRefresh: _refresh,
      refreshIndicatorExtent: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      // indicatorBuilder: (context,mode,d1,d2,d3){
      //   return LinearProgressIndicator();
      // },
      itemCount: dp.loadingResTasks?5:dp.resTasks.length,
      itemBuilder: (context, index) => Column(
        children: [
          dp.loadingResTasks
              ? buildTasksHisSkeleton(context)
              : buildTaskHisCard(dp.resTasks[index], context),
          if (index != dp.resTasks.length - 1) const Divider()
        ],
      ),
    );
  }

  Widget buildHeader(DashboardProvider dp) {
    return Stack(
      children: [
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
                    Expanded(
                      child: h4Text('Collab History', color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   left: 10,
        //   child: Row(
        //     children: [
        //       const Text('Total: '),
        //       Text(
        //         dp.resTasks.length.toString(),
        //         style: const TextStyle(color: Colors.blue),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Padding buildTasksHisSkeleton(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TaskSkeleton(),
    );
  }

  Padding buildTaskHisCard(ResTaskModel task, BuildContext context) {
    String heroTag = task.task!.image != null
        ? '${task.task!.image ?? ''}${task.task!.title!}${task.task!.description ?? ''}1'
        : '${task.task!.title ?? ''}${task.task!.description ?? ''}1';
    int status = task.status!;
    if ((DateTime.parse(task.task!.expireDate!)).isBefore(DateTime.now()) &&
        task.status != 2) {
      status = 5;
      print(task.task!.expireDate);
    }
    if (task.type == 'Rejected') {
      status = 4;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: status != 5
            ? () {
                Navigator.push(
                    Get.context!,
                    slideLeftRoute(
                        TaskDetailsPage(
                          task: task.task!,
                          status: status,
                          reason: task.reason,
                          response: 1,
                          heroTag: heroTag,
                        ),
                        effect: PageTransitionType.rightToLeftJoined,
                        current: const CollabHistoryPage()));
              }
            : null,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(0),
          child: Container(
            padding: const EdgeInsets.all(10),
            // height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: status == 5 || status == 4 ? Colors.grey[200] : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Hero(
                          tag: heroTag,
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: isOnline
                                  ? buildCachedNetworkImage(
                                      imageUrl: App.imageBase +
                                          (task.task!.image ?? ''),
                                    )
                                  : Image.asset('assets/images/noInternet.png'),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.task!.mainTitle ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                // fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          GestureDetector(
                            onTap: () async => shareThisTask(task.task!),
                            child: Image.asset('assets/images/share.png',
                                width: 20),
                          ),
                        ],
                      ),
                      if (task.task!.mainTitle != null)
                        const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.task!.title ?? "",
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            NumberFormat.simpleCurrency(name: '??? ')
                                .format(double.parse(task.task!.amount ?? '0')),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Builder(builder: (context) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                color: status == 0
                                    ? Colors.amber[50]
                                    : status == 1
                                        ? App.themecolor1.withOpacity(0.1)
                                        : status == 2
                                            ? Colors.green[50]
                                            : status == 3
                                                ? Colors.pink[50]
                                                : status == 4
                                                    ? Colors.red[100]
                                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: status == 0
                                        ? Colors.amber
                                        : status == 1
                                            ? App.themecolor1
                                            : status == 2
                                                ? Colors.green
                                                : status == 3
                                                    ? Colors.pink
                                                    : status == 4
                                                        ? Colors.red
                                                        : Colors.grey),
                              ),
                              child: Text(
                                status == 0
                                    ? 'Pending'
                                    : status == 1
                                        ? 'Under Moderate*'
                                        : status == 2
                                            ? 'Completed'
                                            : status == 3
                                                ? 'Re-Upload'
                                                : status == 4
                                                    ? 'Rejected'
                                                    : 'Expired',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: status == 0
                                            ? Colors.amber
                                            : status == 1
                                                ? App.themecolor1
                                                : status == 2
                                                    ? Colors.green
                                                    : status == 3
                                                        ? Colors.pink
                                                        : status == 4
                                                            ? Colors.red
                                                            : Colors.grey),
                              ),
                            );
                          }),
                          const SizedBox(width: 10),
                          Text(
                            timeBefore(task.createdAt ?? ''),
                            style: Theme.of(context).textTheme.caption!,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
