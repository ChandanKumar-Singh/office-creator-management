import 'package:creater_management/functions/functions.dart';
import 'package:creater_management/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/gradient.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../constants/app.dart';
import '../constants/widgets.dart';
import '../models/taskModel.dart';
import '../providers/dashBoardController.dart';
import '../widgets/CustomDrawer.dart';
import '../widgets/drawerButton.dart';

class UploadProofPage extends StatefulWidget {
  const UploadProofPage({Key? key, required this.task, required this.reason})
      : super(key: key);
  final TaskModel task;
  final String? reason;
  @override
  State<UploadProofPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<UploadProofPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int selectedBottomIndex = 0;
  TextEditingController urlController = TextEditingController();
  TextEditingController desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dp, _) {
      return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey[200],
          drawer: const CustomDrawer(),
          body: Stack(
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
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(Icons.arrow_back_rounded,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          // DrawerButton(scaffoldKey: _scaffoldKey),
                          const SizedBox(width: 10),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              buildCard(dp),
            ],
          ));
    });
  }

  Container buildCard(DashboardProvider dp) => Container(
        // height: Get.height > 700 ? Get.height  : Get.height,
        // color: Colors.red,

        padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
        child: Column(
          children: [
            const SizedBox(height: 140),
            Expanded(
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                )),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          h6Text(
                            'Proof of work',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 5),
                          capText(
                              'Please share all relevant details to proof your original work',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              height: 1.0),
                          const SizedBox(height: 5),
                          const SizedBox(height: 20),
                          buildLinkForm(),
                          const SizedBox(height: 15),
                          buildDescriptionForm(),
                          const SizedBox(height: 15),
                          if (widget.reason != null)
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: App.themecolor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      b1Text(
                                        "Reason: ",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.withOpacity(1),
                                      ),
                                      b1Text(
                                        widget.reason ?? '',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(1),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          buildUploadButton(dp),
                          const SizedBox(height: 15),
                          buildSubmitButton(dp),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  // floatingActionButton: buildFloatingSaveButton(dp),
                ),
              ),
            ),
          ],
        ),
      );

  buildFloatingSaveButton(DashboardProvider dp) {
    return ElevatedButton.icon(
      onPressed: () async {
        if (dp.imageFile == null) {
          Fluttertoast.showToast(msg: 'Please select a file');
        } else if (urlController.text.isEmpty) {
          Fluttertoast.showToast(msg: 'Please add a url');
        } else if (desController.text.isEmpty) {
          Fluttertoast.showToast(msg: 'Please add a description');
        } else {
          var res = await dp.userSubmitCompletedTask(
              taskId: widget.task.id!,
              addedUrl: urlController.text,
              description: desController.text,
              image: dp.imageFile!);
          dp.getResTasks();
          dp.getTasks();
          if (res == 200) {
            Get.back();
            Get.back();
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      icon: const Icon(Icons.file_upload_rounded),
      label: h6Text(
        'Save',
        color: Colors.white,
      ),
    );
  }

  Column buildLinkForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: urlController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero),
                    hintText: 'Paste Published Link',
                    hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withOpacity(0.7))),
              ),
            ),
          ],
        )
      ],
    );
  }

  Column buildDescriptionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: desController,
                maxLines: 6,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero),
                    hintText: 'Anything more you want to tell?',
                    hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withOpacity(0.7))),
              ),
            ),
          ],
        )
      ],
    );
  }

  buildUploadButton(DashboardProvider dp) => Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () async {
              var image = await pickImage(ImageSource.gallery);
              if (image != null) {
                dp.imageFile = image;
                setState(() {});
              } else {
                Fluttertoast.showToast(msg: 'File not selected.');
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: App.themecolor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: h6Text(
                        dp.imageFile != null
                            ? dp.imageFile!.path.split('/').last
                            : 'Upload Screenshot',
                        fontWeight: FontWeight.bold,
                        maxLine: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ))
        ],
      );

  buildSubmitButton(DashboardProvider dp) => Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () async {
              if (dp.imageFile == null) {
                Fluttertoast.showToast(msg: 'Please select a file');
              } else if (urlController.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Please add a url');
              } else if (desController.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Please add a description');
              } else {
                var res = await dp.userSubmitCompletedTask(
                    taskId: widget.task.id!,
                    addedUrl: urlController.text,
                    description: desController.text,
                    image: dp.imageFile!);
                dp.getResTasks();
                dp.getTasks();
                if (res == 200) {
                  Get.back();
                  Get.back();
                }
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(
                    color: App.themecolor,
                    width: 2,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  h6Text(
                    'Submit',
                    fontWeight: FontWeight.bold,
                    color: App.themecolor,
                  )
                ],
              ),
            ),
          ))
        ],
      );
}
