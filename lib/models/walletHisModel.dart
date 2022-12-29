import 'package:creater_management/models/taskModel.dart';

class WalletHisModel {
  int? id;
  int? userId;
  int? taskId;
  String? amount;
  String? comment;

  String? type;
  String? createdAt;
  String? updatedAt;
  TaskModel? task;

  WalletHisModel(
      {this.id,
        this.userId,
        this.taskId,
        this.amount,
        this.comment,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.task});

  WalletHisModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    taskId = json['task_id'];
    amount = json['amount'];
    comment = json['comment'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    task = json['task'] != null ? TaskModel.fromJson(json['task']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['task_id'] = taskId;
    data['amount'] = amount;
    data['comment'] = comment;

    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (task != null) {
      data['task'] = task!.toJson();
    }
    return data;
  }
}
