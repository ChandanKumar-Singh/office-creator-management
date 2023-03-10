import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class TaskSkeleton extends StatelessWidget {
  const TaskSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 01,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(0),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Skeleton(
                        height: 60,
                        width: 60,
                        style: SkeletonStyle.box,
                      ),
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Skeleton(height: 12, style: SkeletonStyle.text),
                      ),
                      const SizedBox(width: 100),
                      Skeleton(
                          height: 12, width: 20, style: SkeletonStyle.text),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Skeleton(height: 14, style: SkeletonStyle.text),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Skeleton(height: 10, style: SkeletonStyle.text),
                      ),
                      const Spacer(
                        flex: 10,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(
                        flex: 3,
                      ),
                      Expanded(
                          flex: 1,
                          child:
                              Skeleton(height: 20, style: SkeletonStyle.text)),
                    ],
                  ),
                ],
              ),
              // child: Text('oinfd'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget showSkeleton({required Widget child}) {
  return SkeletonLoader(
    builder: child,
    items: 1,
    period: const Duration(seconds: 1),
    baseColor: Colors.grey.withOpacity(0.1),
    highlightColor:
        Theme.of(Get.context!).colorScheme.background.withOpacity(0.05),
    direction: SkeletonDirection.ltr,
  );
}
