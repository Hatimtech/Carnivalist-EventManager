abstract class UserEvent {}

class GetLoginDetails extends UserEvent {
}

class ClearLoginDetails extends UserEvent {
}

class SaveUserName extends UserEvent {
  final String username;
  SaveUserName({this.username});
}

class SaveUserId extends UserEvent {
  final String userId;
  SaveUserId({this.userId});
}

class SavAuthToken extends UserEvent {
  final String authToken;
  SavAuthToken({this.authToken});
}

class SaveIsLogin extends UserEvent {
  final bool isLogin;
  SaveIsLogin({this.isLogin});
}

class SaveToken extends UserEvent {
  final String token;
  SaveToken({this.token});
}

class RemoveToken extends UserEvent {
  final String token;
  RemoveToken({this.token});
}

class SaveEmail extends UserEvent {
  final String email;
  SaveEmail({this.email});
}

class SaveMobile extends UserEvent {
  final String mobile;
  SaveMobile({this.mobile});
}

class SaveProfilePicture extends UserEvent{
  final String profilePicture;
  SaveProfilePicture({this.profilePicture});
}

class SaveAddress extends UserEvent {
  final String address;
  SaveAddress({this.address});
}
