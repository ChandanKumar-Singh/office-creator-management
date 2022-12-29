import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app.dart';
import '../functions/functions.dart';
import '../models/createrModel.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  late Creator creator;
  List recommendedBio = [];
  XFile? imageFile;
  bool uploadingImage = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController instaUserNameController = TextEditingController();
  TextEditingController ytUrlController = TextEditingController();
  TextEditingController ytSubscribersController =
      TextEditingController(text: '0');
  TextEditingController instaFollowersController =
      TextEditingController(text: '');
  TextEditingController incomeController = TextEditingController();

  Future<void> initRecommendedBio() async {
    if (creator.data != null) {
      recommendedBio.clear();
      firstNameController.text = creator.data!.firstName ?? '';
      lastNameController.text = creator.data!.lastName ?? '';
      emailController.text = creator.data!.email ?? '';
      addressController.text = creator.data!.address ?? '';
      phoneController.text = creator.data!.phone ?? '';
      instaUserNameController.text = creator.data!.insta_username ?? '';
      instaFollowersController.text = creator.data!.instaFollowers != null
          ? creator.data!.instaFollowers.toString()
          : '';

      ytSubscribersController.text = creator.data!.youtubeSubscribers != null
          ? creator.data!.youtubeSubscribers.toString()
          : '';
      print(creator.data!.youtubeUrl);
      ytUrlController.text = creator.data!.youtubeUrl ?? '';
      notifyListeners();
    }
  }

  refreshUser() async {
    await initRecommendedBio();
    Future.delayed(const Duration(seconds: 5), () async {
      await updateProfile(homePage: true);
    });
  }

  Future<void> updateImage(bool isProfile) async {
    uploadingImage = true;

    try {
      if (isOnline) {
        var url = App.baseUrl + App.userUpdateProfilePic;
        var headers = {
          'Accept': '*/*',
          'Authorization': 'Bearer ${creator.token}'
        };
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );
        imageFile = await pickImage(ImageSource.gallery);
        notifyListeners();

        if (imageFile != null) {
          request.files
              .add(await http.MultipartFile.fromPath('image', imageFile!.path));
          request.headers.addAll(headers);
          var res = await request.send();
          var responseData = await res.stream.toBytes();

          var result = String.fromCharCodes(responseData);
          print('res ------> $result');

          if (res.statusCode == 200) {}
          if (isProfile) {
            Fluttertoast.showToast(msg: jsonDecode(result)['message']);
          }
          await initiateUser(route: false);
          uploadingImage = false;
          notifyListeners();
        } else {
          Fluttertoast.showToast(msg: 'Image not selected');
        }
      } else {
        showNetWorkToast(msg: 'You are offline. Please connect to network');
      }
    } catch (e) {
      print('e e e e e e e userUpdateProfilePic  e  ee e  e ---> $e');
    }

    uploadingImage = false;
    notifyListeners();
  }

  Future<bool> updateProfile({required bool homePage}) async {
    bool success = false;

    try {
      if (!homePage) {
        hoverBlankLoadingDialog(true);
      }
      if (isOnline) {
        var url = App.baseUrl + App.complete_profile;
        var headers = {
          'Accept': '*/*',
          'Authorization': 'Bearer ${creator.token}'
        };
        var body = {
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "email": emailController.text,
          "address": addressController.text,
          "insta_followers": instaFollowersController.text,
          "youtube_subscribers": ytSubscribersController.text,
          "youtube_url": ytUrlController.text,
          "insta_username": instaUserNameController.text,
        };
        print('complete profile update parameters $body');
        var res = await http.post(Uri.parse(url), headers: headers, body: body);
        print('complete profile response ${res.body}');

        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['status'] == 200) {
            await initiateUser(route: false);
            success = true;
          } else {
            success = false;
          }
          if (!homePage) {
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        }
      } else {
        success = false;
        showNetWorkToast(msg: 'You are offline. Please connect to network');
      }
    } catch (e) {
      success = false;
      print('e e e e e e e   e  ee e  e ---> $e');
    }
    if (!homePage) {
      hoverBlankLoadingDialog(false);
    }
    print(' success success success success $success');

    return success;
  }
}
// {
// "first_name":"Manoj",
// "last_name":"Manoj",
// "email":"manoj@gmail.com",
// "address":"123 lko",
// "insta_followers":100,
// "insta_subscribers":500,
// "youtube_followers":200,
// "youtube_subscribers":100
// }
