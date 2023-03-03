import 'dart:io';
import 'dart:math';

import 'package:creater_management/constants/app.dart';
import 'package:creater_management/models/GenresModel.dart';
import 'package:creater_management/providers/authProvider.dart';
import 'package:creater_management/providers/dashBoardController.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
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
  const CompleteProfilePage({Key? key, this.fromInside = false})
      : super(key: key);
  final bool fromInside;
  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  bool showErrorText = false;
  bool urlVerified = false;
  bool instaVerified = false;
  bool loadingYtSub = false;
  bool loadingInsta = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  late MultiValueDropDownController _cntMulti;

  @override
  void dispose() {
    _cnt.dispose();
    _cntMulti.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cnt = SingleValueDropDownController();
    _cntMulti = MultiValueDropDownController();
    var up = Provider.of<UserProvider>(context, listen: false);
    var dp = Provider.of<DashboardProvider>(context, listen: false);

    ///bio
    up.initRecommendedBio();

    ///yt
    if (up.ytUrlController.text.isNotEmpty) {
      setState(() {
        urlVerified = true;
      });
    }

    ///instagram
    if (up.instaFollowersController.text.isNotEmpty &&
        up.instaFollowersController.text != '0') {
      setState(() {
        instaVerified = true;
      });
    }
    up.initRecommendedBio();

    ///genres
    debugPrint('user has  genres ${up.creator.data!.genres}');
    if (up.creator.data!.genres != null &&
        up.creator.data!.genres!.isNotEmpty) {
      up.selectedGenres.clear();
      for (var item in up.creator.data!.genres!) {
        GenresModel genresModel =
            dp.genreses.firstWhere((genres) => genres.id == item);
        DropDownValueModel dropDownValueModel = DropDownValueModel(
            name: genresModel.title ?? '', value: genresModel.id ?? 0);
        debugPrint('dropDownValueList ${dropDownValueModel}');
        _cntMulti.dropDownValueList ??= [];
        _cntMulti.dropDownValueList?.add(dropDownValueModel);
        up.selectedGenres.add(dropDownValueModel);
        setState(() {});
      }
    }
    checkErrorText(up);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, up, _) {
      debugPrint('show error text $showErrorText');
      debugPrint('urlVerified $urlVerified');
      debugPrint('dropDownValueList ${_cntMulti.dropDownValueList}');
      return Consumer<DashboardProvider>(builder: (context, dsp, _) {
        return Scaffold(
          backgroundColor: App.themecolor1.withOpacity(0.9),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
                // child: Center(child: Text('Testing  Welcome'),),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.fromInside)
                      Column(
                        children: [
                          const SizedBox(height: 10),
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
                            ],
                          ),
                        ],
                      ),
                    SizedBox(height: widget.fromInside ? 10 : 50),

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
                    const SizedBox(height: 20),
                    buildGenresForm(dsp, up),
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
    });
  }

  Widget buildGenresForm(DashboardProvider dsp, UserProvider up) {
    return Column(
      children: [
        DropDownTextField.multiSelection(
          controller: _cntMulti,
          // initialValue: const ["name1", "name2", "name8", "name3"],
          dropDownList: [
            ...dsp.genreses.map(
              (genres) {
                return DropDownValueModel(
                    name: genres.title ?? '',
                    value: genres.id ?? Random().nextInt(1000));
              },
            ),
          ],
          onChanged: (val) {
            setState(() {
              up.selectedGenres = val.map((e) => e).toList();
              checkErrorText(up);
              print(up.selectedGenres.length);
            });
          },
          submitButtonText: 'Done',
          submitButtonColor: App.themecolor1,
          submitButtonTextStyle: const TextStyle(color: Colors.white),
          textFieldDecoration: InputDecoration(
              labelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              labelText: 'Genres'),
          textStyle: const TextStyle(color: Colors.white),
          clearIconProperty: IconProperty(color: Colors.blue),
          dropDownIconProperty: IconProperty(color: Colors.white),
        ),
        if (up.selectedGenres.isEmpty)
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: capText(
                  'You must have to choose your genres',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white),
                ),
              ))
            ],
          ),
        if (up.selectedGenres.isNotEmpty)
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            direction: Axis.horizontal,
            spacing: 10,
            children: [
              ...up.selectedGenres.map(
                (e) => Chip(
                  label: capText(
                    e.name,
                  ),
                  deleteIcon: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                  onDeleted: () {
                    up.selectedGenres
                        .removeWhere((element) => element.value == e.value);
                    _cntMulti.dropDownValueList!
                        .removeWhere((element) => element.value == e.value);
                    checkErrorText(up);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
      ],
    );
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

        if(!widget.fromInside)
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0))),
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
        if(!widget.fromInside)
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0))),
              onPressed: showErrorText
                  ? null
                  : () async {
                      checkErrorText(up);

                      if (!showErrorText) {
                        try {
                          if (up.instaUserNameController.text.isNotEmpty &&
                              instaVerified) {
                            var countText = await getInstaSubscribers(
                                up.instaUserNameController.text);
                            debugPrint(countText.toString());
                            if (countText > 0) {
                              up.instaFollowersController.text = '$countText';
                            }
                          }
                          if (up.ytUrlController.text.isNotEmpty &&
                              urlVerified) {
                            var countText = await getYouTubeSubscribers(
                                videoId: up.ytUrlController.text,
                                channelName: 'Aviral   kapasia');
                            debugPrint(countText.toString());
                            if (countText > 0) {
                              up.ytSubscribersController.text = '$countText';
                            }
                          }
                        } catch (e) {
                          debugPrint(
                              'TRYING TO RE-VERIFY  URLS AND USERNAME ERROR $e');
                        }
                        var success = await up.updateProfile(homePage: false);
                        if (success) {
                          Get.offAll(const HomePage());
                        }
                      }
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:  [
                  Text(widget.fromInside?'Update':'Get Started'),
                  if(!widget.fromInside)
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
                                    debugPrint(countText.toString());

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
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
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
                  child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'You have ${up.ytSubscribersController.text} subscribers on Youtube',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white),
                ),
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
  //                                     debugPrint(countText);
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
                                      // 'apnamotiv');
                                      debugPrint(countText.toString());

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
                                                'Verification failed.Please try again');
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
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
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
                  child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'You have ${up.instaFollowersController.text} followers on instagram',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white),
                ),
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
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
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
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    labelText: 'Address '),
              ),
            ),
          ],
        ),
        if (showErrorText)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '* Address is Required',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white),
                  ),
                ),

              )
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
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
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
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
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
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
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
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    labelText: 'First Name '),
              ),
            ),
          ],
        ),
        if (showErrorText)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '* Name is Required',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white),
                  ),
                ),

              )
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
        up.phoneController.text.isEmpty ||
        up.selectedGenres.isEmpty) {
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
