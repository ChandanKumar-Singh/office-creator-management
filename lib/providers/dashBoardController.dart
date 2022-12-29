import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:creater_management/constants/app.dart';
import 'package:creater_management/models/taskModel.dart';
import 'package:creater_management/models/walletHisModel.dart';
import 'package:creater_management/providers/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../functions/functions.dart';

class DashboardProvider extends ChangeNotifier {
  bool loadingTasks = false;
  List<TaskModel> tasks = <TaskModel>[];
  int getTasksPage = 1;
  int total = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  int selectedBottomIndex = 0;
  void setBottomIndex(int index) {
    selectedBottomIndex = index;
    notifyListeners();
  }

  Future<void> getTasks() async {
    var response;
    // tasks.clear();
    // notifyListeners();
    try {
      bool cacheExist = await APICacheManager().isAPICacheKeyExist('tasks');
      getTasksPage = 1;

      if (isOnline) {
        var url = '${App.baseUrl}${App.getTasks}?page=$getTasksPage';
        var headers = {
          'Accept': '*/*',
          'Authorization': 'Bearer ${prefs.getString('token')!}'
        };
        var res = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode({}));
        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['success'] == 200) {
            var data = jsonDecode(res.body)['data'];
            var cacheModel =
                APICacheDBModel(key: 'tasks', syncData: jsonEncode(data));

            await APICacheManager().addCacheData(cacheModel);
            response = cacheModel.syncData;
          } else {
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        }
        print("it's url Hit  $response ");
      } else {
        showNetWorkToast();
        if (cacheExist) {
          response = (await APICacheManager().getCacheData('tasks')).syncData;
          print("it's cache Hit $response");
        }
      }
      response = jsonDecode(response);
      if (response != null) {
        tasks.clear();

        if (response != 0) {
          total = response['total'];
          response['data'].forEach((e) {
            TaskModel task = TaskModel.fromJson(e);
            bool isQlf = isQualified(task.type ?? '',
                task.taskInstaFollowers ?? task.taskYoutubeSubscribers!);
            if (isQlf) {
              tasks.add(task);
            }
          });
        } else {
          total = response;
        }
      }
    } catch (e) {
      debugPrint('e e e e e e get tasks e -> $e');
    }

    print('testing tasks ------ >$total    ${tasks.length}');
    notifyListeners();
  }

  Future<void> loadMoreTasks() async {
    try {
      if (isOnline) {
        getTasksPage++;
        var url = '${App.baseUrl}${App.getTasks}?page=$getTasksPage';
        var headers = {
          'Accept': '*/*',
          'Authorization': 'Bearer ${prefs.getString('token')!}'
        };
        var res = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode({}));
        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['success'] == 200) {
            var response = jsonDecode(res.body)['data'];
            response['data'].forEach((e) {
              tasks.add(TaskModel.fromJson(e));
            });
          } else {
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        }
      } else {
        showNetWorkToast();
      }
    } catch (e) {
      debugPrint('e e e e e e e -> $e');
    }

    print('testing tasks ------ >$total    ${tasks.length}');
    notifyListeners();
  }

  bool loadingResTasks = false;
  List<ResTaskModel> resTasks = <ResTaskModel>[];
  int getResTasksPage = 1;
  int resTotal = 0;

  Future<void> getResTasks() async {
    var response;
    // tasks.clear();
    // notifyListeners();
    // print(Provider.of<UserProvider>(Get.context!, listen: false)
    //     .creator
    //     .data!
    //     .toJson());

    try {
      bool cacheExist = await APICacheManager().isAPICacheKeyExist('resTasks');
      getResTasksPage = 1;

      if (isOnline) {
        var url =
            '${App.baseUrl}${App.userTaskResponseHistories}?page=$getResTasksPage';
        var headers = {'Accept': '*/*', 'Authorization': 'Bearer $token'};
        var res = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode({}));
        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['success'] == 200) {
            var data = jsonDecode(res.body)['data'];
            var cacheModel =
                APICacheDBModel(key: 'resTasks', syncData: jsonEncode(data));

            await APICacheManager().addCacheData(cacheModel);
            response = cacheModel.syncData;
          } else {
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        }
        print("it's url Hit  $response ");
      } else {
        showNetWorkToast();
        if (cacheExist) {
          response =
              (await APICacheManager().getCacheData('resTasks')).syncData;
          print("it's cache Hit $response");
        }
      }
      response = jsonDecode(response);
      if (response != null) {
        resTasks.clear();

        if (response != 0) {
          resTotal = response['total'];
          response['data'].forEach((e) {
            resTasks.add(ResTaskModel.fromJson(e));
          });
        } else {
          resTotal = response;
        }
      }
    } catch (e) {
      debugPrint('e e e e get res tasks e e e -> $e');
    }

    print('testing tasks ------ >$resTotal    ${resTasks.length}');
    notifyListeners();
  }

  Future<void> loadMoreResTasks() async {
    try {
      if (isOnline) {
        getResTasksPage++;
        var url =
            '${App.baseUrl}${App.userTaskResponseHistories}?page=$getResTasksPage';
        var headers = {'Accept': '*/*', 'Authorization': 'Bearer $token'};
        var res = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode({}));
        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['success'] == 200) {
            var response = jsonDecode(res.body)['data'];
            response['data'].forEach((e) {
              resTasks.add(ResTaskModel.fromJson(e));
            });
          } else {
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        }
      } else {
        showNetWorkToast();
      }
    } catch (e) {
      debugPrint('e e e e e e res tasks e -> $e');
    }

    print('testing tasks ------ >$resTotal    ${resTasks.length}');
    notifyListeners();
  }

  bool loadingWalletTasks = false;
  List<WalletHisModel> wallTasks = <WalletHisModel>[];
  int getWallTasksPage = 1;
  int wallTotal = 0;

  Future<void> getWallTasks() async {
    var response;
    // tasks.clear();
    // notifyListeners();
    try {
      bool cacheExist = await APICacheManager().isAPICacheKeyExist('wallet');
      getWallTasksPage = 1;

      if (isOnline) {
        var url = '${App.baseUrl}${App.getwallet}?page=$getWallTasksPage';
        var headers = {'Accept': '*/*', 'Authorization': 'Bearer $token'};
        var res = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode({}));
        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['success'] == 200) {
            var data = jsonDecode(res.body)['data'];
            var cacheModel =
                APICacheDBModel(key: 'wallet', syncData: jsonEncode(data));

            await APICacheManager().addCacheData(cacheModel);
            response = cacheModel.syncData;
          } else {
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        }
        print("it's url get wallet Hit  $response ");
      } else {
        showNetWorkToast();
        if (cacheExist) {
          response = (await APICacheManager().getCacheData('wallet')).syncData;
          print("it's cache Hit $response");
        }
      }
      response = jsonDecode(response);
      if (response != null) {
        print(response.runtimeType);
        wallTasks.clear();

        if (response != 0) {
          wallTotal = response['total'];
          response['data'].forEach((e) {
            wallTasks.add(WalletHisModel.fromJson(e));
          });
        } else {
          wallTotal = response;
        }
      }
    } catch (e) {
      debugPrint('e e e e e  wallTasks e e -> $e');
    }

    print('testing tasks ------ >$wallTotal    ${wallTasks.length}');
    notifyListeners();
  }

  Future<void> loadMoreWallTasks() async {
    try {
      if (isOnline) {
        getWallTasksPage++;
        var url = '${App.baseUrl}${App.getwallet}?page=$getWallTasksPage';
        var headers = {'Accept': '*/*', 'Authorization': 'Bearer $token'};
        var res = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode({}));
        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['success'] == 200) {
            var response = jsonDecode(res.body)['data'];
            response['data'].forEach((e) {
              wallTasks.add(WalletHisModel.fromJson(e));
            });
          } else {
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        }
      } else {
        showNetWorkToast();
      }
    } catch (e) {
      debugPrint('e e e e e e wallTasks  e -> $e');
    }

    print('testing tasks ------ >$wallTotal    ${wallTasks.length}');
    notifyListeners();
  }

  Future<int> userAcceptOrReject(int taskId, int accept) async {
    int result = 0;
    if (Provider.of<UserProvider>(Get.context!, listen: false)
            .creator
            .data!
            .status ==
        'Active') {
      hoverBlankLoadingDialog(true);
      try {
        if (isOnline) {
          var url = '${App.baseUrl}${App.userResponseToTask}';
          var headers = {'Accept': '*/*', 'Authorization': 'Bearer $token'};
          var body = {
            "task_id": taskId.toString(),
            "type": accept == 0 ? "Rejected" : "Accepted"
          };
          print('response body $body');
          var res =
              await http.post(Uri.parse(url), headers: headers, body: body);
          if (res.statusCode == 200) {
            if (jsonDecode(res.body)['success'] == 200) {
              result = 200;
              if (accept == 1) {
                await getResTasks();
              }
              Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
            }
          }
        } else {
          showNetWorkToast();
        }
      } catch (e) {
        debugPrint('e e e e e e response on task e -> $e');
      }
      hoverBlankLoadingDialog(false);
    } else {
      showNotVerifiedDialog(
          Provider.of<UserProvider>(Get.context!, listen: false)
                  .creator
                  .data!
                  .status ==
              'Active',true);
    }
    return result;
  }

  Future<int> uploadProof(int taskId, int accept) async {
    int result = 0;
    hoverBlankLoadingDialog(true);
    try {
      if (isOnline) {
        var url = '${App.baseUrl}${App.userResponseToTask}';
        var headers = {'Accept': '*/*', 'Authorization': 'Bearer $token'};
        var body = {
          "task_id": taskId.toString(),
          "type": accept == 0 ? "Rejected" : "Accepted"
        };
        print('response body $body');
        var res = await http.post(Uri.parse(url), headers: headers, body: body);
        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['success'] == 200) {
            result = 200;
            if (accept == 1) {
              await getResTasks();
            }
            Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
          }
        }
      } else {
        showNetWorkToast();
      }
    } catch (e) {
      debugPrint('e e e e e e response on task e -> $e');
    }
    hoverBlankLoadingDialog(false);
    return result;
  }

  XFile? imageFile;
  bool uploadingImage = false;
  Future<int> userSubmitCompletedTask({
    required int taskId,
    required String addedUrl,
    required String description,
    required XFile image,
  }) async {
    hoverBlankLoadingDialog(true);
    var resstatus = 0;
    try {
      if (isOnline) {
        var url = App.baseUrl + App.userSubmitCompletedTask;
        var headers = {'Accept': '*/*', 'Authorization': 'Bearer $token'};
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );
        uploadingImage = true;
        notifyListeners();
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
        request.fields['task_id'] = taskId.toString();
        request.fields['description'] = description;
        request.fields['url'] = addedUrl;
        request.headers.addAll(headers);
        var res = await request.send();
        print('res  upload proof------> $res');
        var responseData = await res.stream.toBytes();

        var result = String.fromCharCodes(responseData);

        if (res.statusCode == 200) {
          imageFile = null;
          resstatus = 200;
        }
        Fluttertoast.showToast(msg: jsonDecode(result)['message']);

        uploadingImage = false;
        notifyListeners();
      } else {
        showNetWorkToast(msg: 'You are offline. Please connect to network');
      }
    } catch (e) {
      print('e e e e e e e upload proof  e  ee e  e ---> $e');
    }

    uploadingImage = false;
    notifyListeners();
    hoverBlankLoadingDialog(false);
    return resstatus;
  }
}
