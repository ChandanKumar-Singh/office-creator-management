class Creator {
  String? token;
  String? tokenType;
  String? expiresAt;
  Data? data;
  String? role;
  String? call_relationship_manager;

  Creator({
    this.token,
    this.tokenType,
    this.expiresAt,
    this.data,
    this.role,
    this.call_relationship_manager,
  });

  Creator.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    role = json['role'];
    call_relationship_manager = json['call_relationship_manager'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['token_type'] = tokenType;
    data['expires_at'] = expiresAt;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['role'] = role;
    data['call_relationship_manager'] = call_relationship_manager;
    return data;
  }
}


class Data {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? status;
  String? address;
  String? profilePic;
  String? insta_username;
  String? youtubeUrl;
  int? instaFollowers;
  int? youtubeSubscribers;
  int? isVerified;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  String? fullName;

  Data(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.phone,
      this.status,
      this.address,
      this.profilePic,
      this.instaFollowers,
      this.youtubeSubscribers,
      this.insta_username,
      this.youtubeUrl,
      this.isVerified,
      this.deviceToken,
      this.createdAt,
      this.updatedAt,
      this.fullName});

  Data.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    status = json['status'];
    address = json['address'];
    profilePic = json['profile_pic'];
    instaFollowers = json['insta_followers'];
    youtubeSubscribers = json['youtube_subscribers'];
    insta_username = json['insta_username'];
    youtubeUrl = json['youtube_url'];
    isVerified = json['is_verified'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['status'] = status;
    data['address'] = address;
    data['profile_pic'] = profilePic;
    data['insta_followers'] = instaFollowers;
    data['youtube_subscribers'] = youtubeSubscribers;
    data['insta_username'] = insta_username;
    data['youtube_url'] = youtubeUrl;
    data['is_verified'] = isVerified;
    data['device_token'] = deviceToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['fullName'] = fullName;
    return data;
  }
}


class UserTasksHistory {
  int? total_collab;
  int? pending_task;
  int? completed_collab;
  int? rajected_collab;

  UserTasksHistory({
    this.total_collab,
    this.pending_task,
    this.completed_collab,
    this.rajected_collab,
  });

  UserTasksHistory.fromJson(Map<String, dynamic> json) {
    total_collab = json['total_collab'];
    pending_task = json['pending_task'];
    completed_collab = json['completed_collab'];
    rajected_collab = json['rajected_collab'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_collab'] = total_collab;
    data['pending_task'] = pending_task;
    data['completed_collab'] = completed_collab;

    data['rajected_collab'] = rajected_collab;
    return data;
  }
}
