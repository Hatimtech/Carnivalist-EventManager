class LoginDetail {
  final String name, lastName, email, mobileNumber, avatar, userType, userId;

  LoginDetail(
      {this.name,
      this.lastName,
      this.email,
      this.mobileNumber,
      this.avatar,
      this.userType,
      this.userId});

  factory LoginDetail.fromJson(Map<String, dynamic> json) {
    return LoginDetail(
        name: json['name'],
        lastName: json['lastName'],
        email: json['email'],
        mobileNumber: json['mobileNumber'],
        avatar: json['avatar'],
        userType: json['userType'],
        userId: json['_id']);
  }
}
