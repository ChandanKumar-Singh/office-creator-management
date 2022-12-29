import 'dart:io';

import 'package:creater_management/constants/app.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:loading_animations/loading_animations.dart';

import '../constants/widgets.dart';
import '../functions/functions.dart';
import 'homePage.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  bool showErrorText = false;
  bool urlVerified = false;
  bool instaVerified = false;
  bool loadingYtSub = false;
  bool loadingInsta = false;
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).initRecommendedBio();
    if (Provider.of<UserProvider>(context, listen: false)
        .ytUrlController
        .text
        .isNotEmpty) {
      setState(() {
        urlVerified = true;
      });
    }
    if (Provider.of<UserProvider>(context, listen: false)
            .instaFollowersController
            .text
            .isNotEmpty &&
        Provider.of<UserProvider>(context, listen: false)
                .instaFollowersController
                .text !=
            '0') {
      setState(() {
        instaVerified = true;
      });
    }
    checkErrorText(Provider.of<UserProvider>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, up, _) {
      print('show error text $showErrorText');
      print('urlVerified $urlVerified');
      return Scaffold(
        backgroundColor: App.themecolor1.withOpacity(0.9),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  buildProfilePicCircle(up),
                  const SizedBox(height: 50),
                  buildNameForm(up),
                  const SizedBox(height: 20),
                  buildLastNameForm(up),
                  const SizedBox(height: 20),
                  buildEmailForm(up),
                  const SizedBox(height: 20),
                  buildPhoneForm(up),
                  const SizedBox(height: 20),
                  buildAddressForm(up),
                  // const SizedBox(height: 20),
                  // buildInstaFollowersForm(up),
                  const SizedBox(height: 20),
                  buildInstaUserNameForm(up),
                  // const SizedBox(height: 20),
                  // buildYtChannelIdForm(up),
                  const SizedBox(height: 20),
                  buildYtVideoUrlForm(up),
                  const SizedBox(height: 30),
                  buildLogoutAndStartButtons(context, up),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  buildProfilePicCircle(UserProvider up) {
    return GestureDetector(
      onTap: () async {
        await up.updateImage(true);
      },
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Get.theme.colorScheme.primary,
            radius: kToolbarHeight,
            child: CircleAvatar(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              radius: kToolbarHeight - 2,
              backgroundImage: up.creator.data!.profilePic != null &&
                      up.creator.data!.profilePic != ''
                  ? FileImage(File(
                      '$appTempPath/${up.creator.data!.profilePic!.split('/').last}'))
                  : const AssetImage(
                      'assets/images/NOV-LOGO-red.png',
                    ) as ImageProvider,
            ),
          ),
          if (up.uploadingImage)
            Positioned.fill(
              child: Center(
                child: LoadingBouncingGrid.square(
                  borderColor: Get.theme.colorScheme.primary,
                  borderSize: 3.0,
                  size: 30.0,
                  inverted: false,
                  backgroundColor: Colors.white,
                  duration: const Duration(milliseconds: 2000),
                ),
              ),
            ),
        ],
      ),
    );
  }

  buildLogoutAndStartButtons(BuildContext context, UserProvider up) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false)
                    .logOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  // Icon(Icons.logout),
                  Text('Log Out'),
                ],
              )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: showErrorText
                  ? null
                  : () async {
                      checkErrorText(up);

                      if (!showErrorText) {
                        // await getYouTubeSubscribers(
                        //     videoId: up.ytUrlController.text, channelName: '');
                        var success = await up.updateProfile(homePage: false);
                        if (success) {
                          Get.offAll(const HomePage());
                        }
                      }
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text('Get Started'),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              )),
        ),
      ],
    );
  }

  buildYtVideoUrlForm(UserProvider up) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: urlVerified,
                onChanged: (val) {
                  checkErrorText(up);

                  setState(() {});
                },
                keyboardType: TextInputType.text,
                controller: up.ytUrlController,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 2,
                          color: Colors.white,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: urlVerified
                                ? null
                                : () async {
                                    setState(() {
                                      loadingYtSub = true;
                                    });
                                    var countText = await getYouTubeSubscribers(
                                        videoId: up.ytUrlController.text,
                                        channelName: 'Aviral   kapasia');
                                    print(countText);

                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      setState(() {
                                        loadingYtSub = false;
                                      });
                                    });
                                    if (countText > 0) {
                                      // up.creator.data!.youtubeSubscribers = countText;
                                      up.ytSubscribersController.text =
                                          '$countText';
                                      urlVerified = true;
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Verification failed.Please try again with your another video');
                                      urlVerified = false;
                                    }
                                    checkErrorText(up);
                                  },
                            child: !urlVerified
                                ? b1Text(
                                    'Verify',
                                    color: Colors.blue,
                                  )
                                : loadingYtSub
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ))
                                    : const Icon(Icons.done,
                                        color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  labelText: 'YouTube video url ',
                  hintText: 'Paste your any youtube video url ',
                ),
              ),
            ),
          ],
        ),
        // if (showErrorText)
        //   Row(
        //     children: const [
        //       Expanded(
        //           child: Text(
        //         '* Your own youtube video url is Required',
        //         style: TextStyle(color: Colors.white),
        //       ))
        //     ],
        //   ),
        if (up.ytSubscribersController.text.isNotEmpty &&
            up.ytSubscribersController.text != '0')
          Row(
            children: [
              Expanded(
                  child: Text(
                'You have ${up.ytSubscribersController.text} subscribers on Youtube',
                style: const TextStyle(color: Colors.white),
              ))
            ],
          ),
      ],
    );
  }

  // Column buildYtChannelIdForm(UserProvider up) {
  //   return Column(
  //     children: <Widget>[
  //       Row(
  //         children: [
  //           Expanded(
  //             child: TextFormField(
  //               readOnly: int.parse(up.ytSubscribersController.text) > 0,
  //               onChanged: (val) {
  //                 checkErrorText(up);
  //
  //                 setState(() {});
  //               },
  //               keyboardType: TextInputType.text,
  //               controller: up.ytUrlController,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.normal,
  //                 color: Colors.white,
  //                 fontSize: 20,
  //               ),
  //               decoration: InputDecoration(
  //                   suffixIcon: SizedBox(
  //                     width: 100,
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           height: 50,
  //                           width: 2,
  //                           color: Colors.white,
  //                         ),
  //                         const Spacer(),
  //                         Padding(
  //                           padding: const EdgeInsets.only(right: 8.0),
  //                           child: ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(15),
  //                               ),
  //                               backgroundColor: Colors.white,
  //                             ),
  //                             onPressed: () async {
  //                                     setState(() {
  //                                       loadingYtSub = true;
  //                                     });
  //                                     var countText = await getYtSubscribers(
  //                                         up.ytUrlController.text);
  //                                     print(countText);
  //
  //                                     Future.delayed(const Duration(seconds: 1),
  //                                         () {
  //                                       setState(() {
  //                                         loadingYtSub = false;
  //                                       });
  //                                     });
  //                                     if (countText > 0) {
  //                                       // up.creator.data!.youtubeSubscribers = countText;
  //                                       up.ytUrlController.text = '$countText';
  //                                       urlVerified = true;
  //                                     } else {
  //                                       Fluttertoast.showToast(
  //                                           msg:
  //                                               'Verification failed.Please try again');
  //                                       urlVerified = false;
  //                                     }
  //                                     checkErrorText(up);
  //                                   },
  //                             child: !urlVerified
  //                                 ? b1Text(
  //                                     'Verify',
  //                                     color: Colors.blue,
  //                                   )
  //                                 : loadingYtSub
  //                                     ? const SizedBox(
  //                                         height: 20,
  //                                         width: 20,
  //                                         child: CircularProgressIndicator(
  //                                           color: Colors.white,
  //                                         ))
  //                                     : const Icon(Icons.done,
  //                                         color: Colors.green),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                     borderSide: const BorderSide(
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                     borderSide: const BorderSide(
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                     borderSide: const BorderSide(
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                   labelStyle: const TextStyle(
  //                     fontWeight: FontWeight.normal,
  //                     color: Colors.white,
  //                     fontSize: 20,
  //                   ),
  //                   labelText: 'Youtube channel name'),
  //             ),
  //           ),
  //         ],
  //       ),
  //       if (up.ytSubscribersController.text.isNotEmpty &&
  //           up.ytSubscribersController.text != '0')
  //         Row(
  //           children: [
  //             Expanded(
  //                 child: Text(
  //               'You have ${up.ytSubscribersController.text} subscribers on Youtube',
  //               style: const TextStyle(color: Colors.white),
  //             ))
  //           ],
  //         ),
  //     ],
  //   );
  // }

  Column buildInstaUserNameForm(UserProvider up) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: int.parse(up.instaFollowersController.text) > 0,
                onChanged: (val) {
                  checkErrorText(up);

                  setState(() {});
                },
                keyboardType: TextInputType.text,
                controller: up.instaUserNameController,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    suffixIcon: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 2,
                            color: Colors.white,
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: instaVerified
                                  ? null
                                  : () async {
                                      setState(() {
                                        loadingInsta = true;
                                      });
                                      var countText = await getInstaSubscribers(
                                          up.instaUserNameController.text);
                                      print(countText);

                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        setState(() {
                                          loadingInsta = false;
                                        });
                                      });
                                      if (countText > 0) {
                                        // up.creator.data!.youtubeSubscribers = countText;
                                        up.instaFollowersController.text =
                                            '$countText';
                                        instaVerified = true;
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Verification failed.Please try again with your another video');
                                        instaVerified = false;
                                      }
                                      checkErrorText(up);
                                    },
                              child: !instaVerified
                                  ? b1Text(
                                      'Verify',
                                      color: Colors.blue,
                                    )
                                  : loadingInsta
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ))
                                      : const Icon(Icons.done,
                                          color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    labelText: 'Instagram username'),
              ),
            ),
          ],
        ),
        if (up.instaFollowersController.text.isNotEmpty &&
            up.instaFollowersController.text != '0')
          Row(
            children: [
              Expanded(
                  child: Text(
                'You have ${up.instaFollowersController.text} followers on instagram',
                style: const TextStyle(color: Colors.white),
              ))
            ],
          ),
      ],
    );
  }

  Column buildInstaFollowersForm(UserProvider up) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (val) {
                  checkErrorText(up);

                  setState(() {});
                },
                keyboardType: TextInputType.number,
                controller: up.instaFollowersController,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    labelText: 'Instagram Followers '),
              ),
            ),
          ],
        ),
        // if (showErrorText)
        //   Row(
        //     children: const [
        //       Expanded(
        //           child: Text(
        //         '* Instagram Followers are Required',
        //         style: TextStyle(color: Colors.white),
        //       ))
        //     ],
        //   ),
      ],
    );
  }

  Column buildAddressForm(UserProvider up) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (val) {
                  checkErrorText(up);

                  setState(() {});
                },
                controller: up.addressController,
                maxLines: 3,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    labelText: 'Address '),
              ),
            ),
          ],
        ),
        if (showErrorText)
          Row(
            children: const [
              Expanded(
                  child: Text(
                '* Address is Required',
                style: TextStyle(color: Colors.white),
              ))
            ],
          ),
      ],
    );
  }

  Column buildPhoneForm(UserProvider up) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (val) {
                  checkErrorText(up);

                  setState(() {});
                },
                readOnly: true,
                controller: up.phoneController,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    labelText: 'phone '),
              ),
            ),
          ],
        ),
        // if (showErrorText)
        //   Row(
        //     children: const [
        //       Expanded(
        //           child: Text(
        //         '* Phone is Required',
        //         style: TextStyle(color: Colors.white),
        //       ))
        //     ],
        //   ),
      ],
    );
  }

  Row buildEmailForm(UserProvider up) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: (val) {
              checkErrorText(up);

              setState(() {});
            },
            controller: up.emailController,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 20,
            ),
            decoration: InputDecoration(
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                labelText: 'email '),
          ),
        ),
      ],
    );
  }

  Row buildLastNameForm(UserProvider up) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: (val) {
              checkErrorText(up);

              setState(() {});
            },
            controller: up.lastNameController,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 20,
            ),
            decoration: InputDecoration(
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                labelText: 'Last Name '),
          ),
        ),
      ],
    );
  }

  Column buildNameForm(UserProvider up) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (val) {
                  checkErrorText(up);

                  setState(() {});
                },
                controller: up.firstNameController,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    labelText: 'First Name '),
              ),
            ),
          ],
        ),
        if (showErrorText)
          Row(
            children: const [
              Expanded(
                  child: Text(
                '* Name is Required',
                style: TextStyle(color: Colors.white),
              ))
            ],
          ),
      ],
    );
  }

  checkErrorText(UserProvider up) {
    if (up.firstNameController.text.isEmpty ||
        up.addressController.text.isEmpty ||
        (up.instaFollowersController.text.isEmpty &&
            up.ytSubscribersController.text.isEmpty) ||
        up.phoneController.text.isEmpty) {
      setState(() {
        showErrorText = true;
      });
    } else {
      setState(() {
        showErrorText = false;
      });
    }
  }
}
