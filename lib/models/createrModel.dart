class Creator {
  String? token;
  String? tokenType;
  String? expiresAt;
  Data? data;
  String? role;

  Creator({this.token, this.tokenType, this.expiresAt, this.data, this.role});

  Creator.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = token;
    data['token_type'] = tokenType;
    data['expires_at'] = expiresAt;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['role'] = role;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
