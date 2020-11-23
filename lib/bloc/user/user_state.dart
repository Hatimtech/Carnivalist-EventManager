class UserState {
  final String userId,
      authToken,
      userName,
      lastName,
      mobile,
      email,
      address,
      domainName;
  final bool eventStaff;
  final String profilePicture;
  final bool isLogin;
  dynamic uiMsg;

  UserState({
    this.userId,
    this.authToken,
    this.userName,
    this.lastName,
    this.email,
    this.mobile,
    this.address,
    this.domainName,
    this.eventStaff,
    this.profilePicture,
    this.isLogin,
    this.uiMsg,
  });

  factory UserState.initial() {
    return UserState(
      userId: null,
      authToken: null,
      userName: null,
      lastName: null,
      email: null,
      mobile: null,
      address: null,
      domainName: null,
      eventStaff: false,
      profilePicture: null,
      isLogin: false,
      uiMsg: null,
    );
  }

  UserState copyWith({
    String userId,
    String authToken,
    String userName,
    String lastName,
    String email,
    String mobile,
    String address,
    String domainName,
    bool eventStaff,
    String profilePicture,
    bool isLogin,
    dynamic uiMsg,
  }) {
    return UserState(
      userId: userId,
      authToken: authToken,
      userName: userName,
      lastName: lastName,
      email: email,
      mobile: mobile,
      address: address,
      domainName: domainName,
      eventStaff: eventStaff,
      profilePicture: profilePicture,
      isLogin: isLogin,
      uiMsg: uiMsg,
    );
  }

  UserState copyWithUiMsg(dynamic uiMsg) {
    return UserState(
      userId: this.userId,
      authToken: this.authToken,
      userName: this.userName,
      lastName: this.lastName,
      email: this.email,
      mobile: this.mobile,
      address: this.address,
      domainName: this.domainName,
      eventStaff: this.eventStaff,
      profilePicture: this.profilePicture,
      isLogin: this.isLogin,
      uiMsg: uiMsg,
    );
  }
}
