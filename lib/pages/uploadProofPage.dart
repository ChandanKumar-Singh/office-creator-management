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
          // backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.8),
          drawer: const CustomDrawer(),
          body: Stack(
            children: [
              Stack(
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
                              DrawerButton(scaffoldKey: _scaffoldKey),
                              const SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: Get.height > 700 ? Get.height * 0.9 : Get.height,
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35),
                child: Column(
                  children: [
                    const SizedBox(height: 180),
                    Expanded(
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ClipRect(
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        h6Text(
                                          'Proof of work',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        b1Text(
                                          'Please share all relevant details to proof your original work',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 5),
                                        const SizedBox(height: 20),
                                        buildLinkForm(),
                                        const SizedBox(height: 20),
                                        buildDescriptionForm(),
                                        const SizedBox(height: 20),
                                        if (widget.reason != null)
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                              color: App.themecolor
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                b1Text(
                                                  "Reason: ",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue
                                                      .withOpacity(1),
                                                ),
                                                b1Text(
                                                  widget.reason ?? '',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        const SizedBox(height: 20),
                                        buildUploadButton(dp),
                                        const SizedBox(height: 20),
                                        buildSubmitButton(dp),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // floatingActionButton: buildFloatingSaveButton(dp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }

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
      icon: Icon(Icons.file_upload_rounded),
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
        // h6Text(
        //   'Enter Complete Link',
        //   fontWeight: FontWeight.bold,
        //   color: Colors.grey,
        // ),
        // const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: urlController,
                decoration: InputDecoration(
                    hintText: 'Paste Published Link',
                    hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
        // h6Text(
        //   'Anything more you want to tell?',
        //   fontWeight: FontWeight.bold,
        //   color: Colors.grey,
        // ),
        // const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: desController,
                maxLines: 6,
                decoration: InputDecoration(
                    hintText: 'Anything more you want to tell?',
                    hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.7))),
              ),
            ),
          ],
        )
      ],
    );
  }

  buildUploadButton(DashboardProvider dp) {
    return Row(
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
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: App.themecolor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: h5Text(
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
          // readOnly: true,
          // textAlign: TextAlign.center,
          // decoration: InputDecoration(
          //   fillColor: App.themecolor,
          //   hintText: dp.imageFile != null
          //       ? dp.imageFile!.path
          //           .split('/')
          //           .last
          //       : 'Upload Screenshot',
          //   hintStyle: TextStyle(
          //     fontSize: Get.theme.textTheme
          //         .headline5!.fontSize,
          //     color: Colors.grey,
          //     fontWeight: FontWeight.bold,
          //   ),
          //   suffixIcon: const Icon(
          //       Icons.file_upload_outlined),
          //   border:
          //       const OutlineInputBorder(
          //     borderSide:
          //         BorderSide(width: 5),
          //   ),
          // ),
        ))
      ],
    );
  }

  buildSubmitButton(DashboardProvider dp) {
    return Row(
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
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                // color: App.themecolor,
                border: Border.all(
                  color: App.themecolor,
                  width: 2,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                h5Text(
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
}
