class EditProfileResponse {
  String? displayName;
  String? firstName;
  int? id;
  String? lastName;
  String? message;
  String? profileImage;
  String? streamItProfileImage;
  String? userEmail;
  String? userLogin;

  EditProfileResponse({
    this.displayName,
    this.firstName,
    this.id,
    this.lastName,
    this.message,
    this.profileImage,
    this.streamItProfileImage,
    this.userEmail,
    this.userLogin,
  });

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return EditProfileResponse(
      displayName: json['display_name'],
      firstName: json['first_name'],
      id: json['ID'],
      lastName: json['last_name'],
      message: json['message'],
      profileImage: json['profile_image'],
      streamItProfileImage: json['streamit_profile_image'],
      userEmail: json['user_email'],
      userLogin: json['user_login'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    data['first_name'] = this.firstName;
    data['ID'] = this.id;
    data['last_name'] = this.lastName;
    data['message'] = this.message;
    data['profile_image'] = this.profileImage;
    data['streamit_profile_image'] = this.streamItProfileImage;
    data['user_email'] = this.userEmail;
    data['user_login'] = this.userLogin;
    return data;
  }
}
