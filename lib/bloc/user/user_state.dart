

class UserState {
  final String userId, authToken, userName, mobile, email, address;
  final String profilePicture;
  final bool isLogin;
  dynamic uiMsg;

  UserState({
    this.userId,
    this.authToken,
    this.userName,
    this.email,
    this.mobile,
    this.address,
    this.profilePicture,
    this.isLogin,
    this.uiMsg,
  });

  factory UserState.initial() {
    return UserState(
      userId: null,
      authToken: null,
      userName: null,
      email: null,
      mobile: null,
      address: null,
      profilePicture: null,
      isLogin: false,
      uiMsg: null,
    );
  }

  UserState copyWith({
    String userId,
    String authToken,
    String userName,
    String email,
    String mobile,
    String address,
    String profilePicture,
    bool isLogin,
    dynamic uiMsg,
  }) {
    return UserState(
      userId: userId ?? this.userId,
      authToken: authToken ?? this.authToken,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
      isLogin: isLogin ?? this.isLogin,
      uiMsg: uiMsg,
    );
  }
}
