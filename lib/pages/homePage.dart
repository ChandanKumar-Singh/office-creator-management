import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:creater_management/constants/app.dart';
import 'package:creater_management/models/taskModel.dart';
import 'package:creater_management/pages/profilePage.dart';
import 'package:creater_management/pages/taskDetailspage.dart';
import 'package:creater_management/pages/walletPage.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/dashBoardController.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import '../constants/widgets.dart';
import '../functions/functions.dart';
import '../widgets/CustomDrawer.dart';
import '../widgets/buildCacheImageNetwork.dart';
import '../widgets/taskSckeleton.dart';
import 'collabHistoryPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> bottomList = ['mycollab', 'history', 'wallet', 'myprofile'];

  get willPop => () {
        var dp = Provider.of<DashboardProvider>(context, listen: false);
        if (dp.selectedBottomIndex != 0) {
          bool? isOpen = dp.scaffoldKey.currentState?.isDrawerOpen;
          if (isOpen != null && isOpen) {
            dp.scaffoldKey.currentState?.closeDrawer();
          } else {
            Provider.of<DashboardProvider>(context, listen: false)
                .setBottomIndex(0);
          }
          return Future.delayed(Duration.zero, () => false);
        } else {
          return Future.delayed(Duration.zero, () => true);
        }
      };

  @override
  void initState() {
    super.initState();
    var dp = Provider.of<DashboardProvider>(context, listen: false);
    var up = Provider.of<UserProvider>(context, listen: false);

    dp.scaffoldKey = _scaffoldKey;
    showUnderVerificationDialog();
    up.refreshUser();
  }

  ///Refreshing
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;

  Future<void> _refresh() async {
    var dp = Provider.of<DashboardProvider>(context, listen: false);
    var ap = Provider.of<AuthProvider>(context, listen: false);
    var up = Provider.of<UserProvider>(context, listen: false);
    await dp
        .getTasks()
        .then((value) async => await dp.getUserTasksHistory())
        .then((value) => _controller.sink.add(SwipeRefreshState.hidden));
    setState(() {});
    await ap.login();
    await dp.getGenres();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Consumer<DashboardProvider>(builder: (context, dp, _) {
        return Scaffold(
          key: dp.scaffoldKey,
          backgroundColor: Get.theme.scaffoldBackgroundColor.withOpacity(0.98),
          drawer: const CustomDrawer(),
          bottomNavigationBar: buildBottomNav(dp, context),
          body: dp.selectedBottomIndex == 0
              ? buildMyCollab(dp)
              : dp.selectedBottomIndex == 1
                  ? const CollabHistoryPage()
                  : dp.selectedBottomIndex == 2
                      ? const WalletPage()
                      : const ProfilePage(),
        );
      }),
    );
  }

  Container buildBottomNav(DashboardProvider dp, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...bottomList.map((e) {
            var index = bottomList.indexOf(e);
            return GestureDetector(
              onTap: () {
                setState(() {
                  dp.setBottomIndex(index);
                });
              },
              child: Container(
                color: Colors.transparent,
                height: 60,
                child: Center(
                  child: capText(
                    e,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        color: dp.selectedBottomIndex == index
                            ? Colors.black
                            : Colors.black45,
                        fontWeight: dp.selectedBottomIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: dp.selectedBottomIndex == index ? 18 : 16,
                        letterSpacing: 0,
                        height: 0),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Column buildMyCollab(DashboardProvider dp) {
    return Column(
      children: [
        buildHeader(dp),
        Expanded(
          child: Consumer<DashboardProvider>(builder: (context, dp, _) {
            return !dp.loadingTasks && dp.tasks.isEmpty
                ? buildNoHistory('No task yet')
                : buildSwipeRefresh(dp);
          }),
        ),
      ],
    );
  }

  Stack buildHeader(DashboardProvider dp) {
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
                      child: h4Text('Collaboration', color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SwipeRefresh buildSwipeRefresh(DashboardProvider dp) {
    return SwipeRefresh.builder(
        stateStream: _stream,
        onRefresh: _refresh,
        refreshIndicatorExtent: 100,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        // indicatorBuilder: (context,mode,d1,d2,d3){
        //   return LinearProgressIndicator();
        // },
        itemCount: dp.loadingTasks ? 5 : dp.tasks.length,
        itemBuilder: (context, index) => Column(
              children: [
                dp.loadingTasks
                    ? buildTasksSkeleton(context)
                    : buildTasksCard(dp.tasks[index], context),
                if (index != dp.tasks.length - 1) const Divider()
              ],
            ));
  }

  Padding buildTasksCard(TaskModel task, BuildContext context) {
    String heroTag = task.image != null
        ? '${task.image!}${task.title!}${task.description ?? ''}0'
        : '${task.title!}${task.description ?? ''}0';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          // if(isQlf) {
          Navigator.push(
              Get.context!,
              slideLeftRoute(
                  TaskDetailsPage(task: task, response: 0, heroTag: heroTag),
                  effect: PageTransitionType.rightToLeftJoined,
                  current: const HomePage()));
          // }
        },
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
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: heroTag,
                            child: isOnline
                                ? buildCachedNetworkImage(
                                    imageUrl:
                                        App.imageBase + (task.image ?? ''))
                                : Image.asset('assets/images/noInternet.png'),
                          ),
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
                            child: Text(
                              task.mainTitle ?? "",
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
                            onTap: () async => shareThisTask(task),
                            child: Image.asset('assets/images/share.png',
                                width: 20),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(task.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            NumberFormat.simpleCurrency(
                              name: '₹',
                              // locale: 'Rs.',
                            ).format(double.parse(task.amount ?? '0')),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            timeBefore(task.createdAt ?? ''),
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.bold),
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

  Padding buildTasksSkeleton(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: TaskSkeleton(),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 15;

    Offset start = Offset(0, size.height / 2);
    Offset end = Offset(size.width, size.height / 2);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

shareThisTask(TaskModel task) async {
  HapticFeedback.vibrate();
  final box = Get.context!.findRenderObject() as RenderBox?;

  await Share.share(
    'Hey there is an interesting collaboration on wecollab, #${task.title ?? ''}# ${task.mainTitle != null ? 'by #${task.mainTitle}#' : ''} Go and check now #link for app#',
    subject: 'subject',
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}
