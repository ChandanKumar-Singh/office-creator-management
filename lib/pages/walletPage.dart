import 'dart:async';

import 'package:creater_management/constants/app.dart';
import 'package:creater_management/models/taskModel.dart';
import 'package:creater_management/models/walletHisModel.dart';
import 'package:creater_management/pages/taskDetailspage.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/dashBoardController.dart';
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
import '../widgets/buildCacheImageNetwork.dart';
import '../widgets/taskSckeleton.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List<String> bottomList = ['mycollab', 'history', 'wallet', 'myprofile'];

  ///Refreshing
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  Future<void> _refresh() async {
    var dp = Provider.of<DashboardProvider>(context, listen: false);

    await dp
        .getWallTasks()
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
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: !dp.loadingWalletTasks && dp.wallTasks.isEmpty
                  ? buildNoHistory('No transaction yet')
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
      refreshIndicatorExtent: 300,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: dp.wallTasks.length,
      itemBuilder: (context, index) => Column(
        children: [
          dp.loadingWalletTasks
              ? buildTasksHisSkeleton(context)
              : buildTaskHisCard(dp.wallTasks[index], context),
          if (index != dp.wallTasks.length - 1) const Divider()
        ],
      ),
    );
  }

  Widget buildHeader(DashboardProvider dp) {
    double total = 0;
    for (var element in dp.wallTasks) {
      if (element.type == 'Credited') {
        total += double.parse(element.amount ?? '0');
      } else {
        total -= double.parse(element.amount ?? '0');
      }
    }
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
                    Column(
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
                                const SizedBox(height: 8),
                                Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  width: 35,
                                ),
                                const SizedBox(height: 9),
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
                        const SizedBox(height: 8)
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text('My wallet',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    // fontSize: 40,
                                    color: Colors.white,
                                    // fontWeight: FontWeight.normal,
                                  )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  h6Text(
                    'Current Balance'.toLowerCase(),
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    NumberFormat.simpleCurrency(name: '₹ ').format(total),
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.black.withOpacity(0.7)),

                    // fontWeight: FontWeight.bold,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Payroll: 30th of month',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding buildTasksHisSkeleton(BuildContext context) => const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0), child: TaskSkeleton());

  Padding buildTaskHisCard(WalletHisModel task, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Card(
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
            // color: status == 2 ? Colors.grey[200] : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.task != null)
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: isOnline
                              ? buildCachedNetworkImage(
                                  imageUrl:
                                      App.imageBase + (task.task!.image ?? ''),
                                )
                              : Image.asset('assets/images/noInternet.png'),
                        ),
                      ),
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
                          child: task.task != null
                              ? Text(
                                  task.task!.title ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    // fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                )
                              : const Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                        ),
                        const SizedBox(width: 7),
                        if (task.task != null)
                          Icon(
                            task.task!.isFeatured == 1
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: task.task!.isFeatured == 1
                                ? Colors.red
                                : Colors.grey,
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: task.task != null
                              ? Text(
                                  task.task!.description ?? "",
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  task.comment ?? "",
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (task.task != null)
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                NumberFormat.simpleCurrency(name: '₹ ').format(
                                    double.parse(task.task!.amount ?? '0')),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
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
                              color: task.type == 'Credited'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              task.type == 'Credited'
                                  ? '+${task.amount ?? 0}'
                                  : '-${task.amount ?? 0}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }),
                        const SizedBox(width: 10),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Column buildNoHistory(text, [double height = 100]) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: height,
        child: Image.asset('assets/images/time_loading_no_bg.gif',
            fit: BoxFit.cover)
      ),
      const SizedBox(height: 20),
      h5Text(text),
    ],
  );
}
