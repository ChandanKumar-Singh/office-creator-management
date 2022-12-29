class TaskModel {
  int? id;
  String? title;
  String? image;
  String? description;
  String? mainTitle;
  String? amount;
  String? type;
  String? expireDate;
  int? taskInstaFollowers;
  int? isFeatured;
  int? taskYoutubeSubscribers;
  String? status;
  String? termsConditions;
  String? createdAt;
  String? updatedAt;

  TaskModel(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.mainTitle,
        this.amount,
        this.type,
        this.expireDate,
        this.taskInstaFollowers,
        this.isFeatured,
        this.taskYoutubeSubscribers,
        this.status,
        this.termsConditions,
        this.createdAt,
        this.updatedAt});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    mainTitle = json['main_title'];
    amount = json['amount'];
    type = json['type'];
    expireDate = json['expire_date'];
    taskInstaFollowers = json['task_insta_followers'];
    isFeatured = json['is_featured'];
    taskYoutubeSubscribers = json['task_youtube_subscribers'];
    status = json['status'];
    termsConditions = json['terms_conditions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['description'] = description;
    data['main_title'] = mainTitle;
    data['amount'] = amount;
    data['type'] = type;
    data['expire_date'] = expireDate;
    data['task_insta_followers'] = taskInstaFollowers;
    data['is_featured'] = isFeatured;
    data['task_youtube_subscribers'] = taskYoutubeSubscribers;
    data['status'] = status;
    data['terms_conditions'] = termsConditions;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ResTaskModel {
  int? id;
  int? userId;
  int? taskId;
  String? type;
  int? status;
  String? createdAt;
  String? updatedAt;
  TaskModel? task;

  ResTaskModel(
      {this.id,
        this.userId,
        this.taskId,
        this.type,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.task});

  ResTaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    taskId = json['task_id'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    task = json['task'] != null ? TaskModel.fromJson(json['task']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['task_id'] = taskId;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (task != null) {
      data['task'] = task!.toJson();
    }
    return data;
  }
}

