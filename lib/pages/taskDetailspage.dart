import 'package:creater_management/constants/app.dart';
import 'package:creater_management/pages/homePage.dart';
import 'package:creater_management/pages/uploadProofPage.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/dashBoardController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../constants/widgets.dart';
import '../functions/functions.dart';
import '../models/taskModel.dart';
import '../widgets/CustomDrawer.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage(
      {Key? key, this.task, this.response, this.heroTag, this.status})
      : super(key: key);
  final TaskModel? task;
  final int? response;
  final String? heroTag;
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

  @override
  Widget build(BuildContext context) {
    print(widget.status);
    return Scaffold(
        key: _scaffoldKey,
        // backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.8),
        drawer: const CustomDrawer(),
        bottomNavigationBar: widget.response != null && widget.response == 0
            ? TaskDetailsAcceptRejectButtons(
                taskId: task.id!,
              )
            : widget.status == 0 || widget.status == 3
                ? TaskDetailsUploadDocsButtons(task: task)
                : const SizedBox.shrink(),
        body: Column(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState?.openDrawer();
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
                              ? Image.network(
                                  App.imageBase + (task.image ?? ''),
                                  width: 100,
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
                              ? Image.network(
                                  App.imageBase + (task.image ?? ''),
                                  width: 100,
                                )
                              : Image.asset('assets/images/noInternet.png',
                                  width: 100),
                        ),
                      const SizedBox(width: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: h6Text(
                              task.mainTitle ?? '',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: h6Text(
                              'Payment ${NumberFormat.simpleCurrency(name: 'INR').format(double.parse(task.amount ?? '0'))}',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.normal,
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: Consumer<DashboardProvider>(builder: (context, dp, _) {
                  return dp.loadingTasks
                      ? SkeletonLoader(
                          builder: Card(
                            elevation: 3,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/images/user.png',
                                          fit: BoxFit.contain,
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
                                            const Expanded(
                                              child: Text(
                                                "    fefey9yfew fewh g                                 ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            InkWell(
                                              onTap: () {},
                                              splashColor: Colors.grey,
                                              radius: 50,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: const Icon(
                                                Icons.favorite_outline,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                "                                          \n                 ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              NumberFormat.simpleCurrency(
                                                      name: 'INR')
                                                  .format(50000),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '   h',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                          items: 1,
                          period: const Duration(seconds: 5),
                          baseColor: Colors.transparent,
                          highlightColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.05),
                          direction: SkeletonDirection.ltr,
                        )
                      : Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.all(0),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            // height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      h6Text(
                                        'Deliverables',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: b1Text(task.description ?? ''))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      h6Text(
                                        'Terms & Conditions',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: b1Text(
                                              task.termsConditions ?? ''))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                }),
              ),
            ),
          ],
        ));
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
      child: Row(
        children: <Widget>[
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: App.themecolor.withOpacity(0.8),
              ),
              onPressed: () async {
                var res = await dp.userAcceptOrReject(taskId, 0);
                if (res != 0) {
                  dp.setBottomIndex(1);

                  Get.back();
                  dp.getResTasks();
                  dp.getTasks();
                }
              },
              child: const Text(
                'REJECT',
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
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
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'ACCEPT',
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
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
  }) : super(key: key);

  final TaskModel task;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: App.yellowButtonColor,
              ),
              onPressed: () {
                Navigator.push(
                    Get.context!,
                    slideLeftRoute(
                        UploadProofPage(
                          task: task,
                        ),
                        effect: PageTransitionType.rightToLeftJoined,
                        current: TaskDetailsPage(
                          task: task,
                        )));
              },
              child: h6Text(
                'UPLOAD PROOF',
                style: const TextStyle(
                  letterSpacing: 2,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
