import 'BaseResponse.dart';
import 'UserPlan.dart';

class LoginResponse extends BaseResponse {
  String? firstName;
  String? lastName;
  String? profileImage;
  String? token;
  String? userEmail;
  int? userId;
  String? userNiceName;
  UserPlan? plan;
  String? username;

  LoginResponse({
    this.firstName,
    this.lastName,
    this.profileImage,
    this.token,
    this.userEmail,
    this.userId,
    this.userNiceName,
    this.plan,
    this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      firstName: json['first_name'],
      lastName: json['last_name'],
      profileImage: json['streamit_profile_image'],
      token: json['token'],
      userEmail: json['user_email'],
      userId: json['user_id'],
      userNiceName: json['user_nicename'],
      plan: json['plan'] != null ? UserPlan.fromJson(json['plan']) : null,
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['streamit_profile_image'] = this.profileImage;
    data['token'] = this.token;
    data['user_email'] = this.userEmail;
    data['user_id'] = this.userId;
    data['user_nicename'] = this.userNiceName;
    if (data['plan'] != null) {
      data['plan'] = this.plan;
    }
    data['username'] = this.username;
    return data;
  }
}
