login check
{"name":"rohit","email":"rohk54@gmail.com","mobile":7869820020,"password":"12345678","userType":"manager"}

username:hatimd80@gmail.com
password:7869820020
userType:manager


        _userBloc.saveIsLogin(false);
        _userBloc.saveUserId('');
        _userBloc.saveEmail('');
        _userBloc.saveMobile('');
        _userBloc.saveProfilePicture('');
        _userBloc.saveUserName('');
        _userBloc.savAuthToken('');

        _userBloc.getLoginDetails();

        Navigator.of(context).pushNamedAndRemoveUntil(
            loginRoute, (Route<dynamic> route) => false);

centerdock
class _CenterDockedFloatingActionButtonLocation
    extends _DockedFloatingActionButtonLocation {
  const _CenterDockedFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
       2.0;
    return Offset(fabX, getDockedY(scaffoldGeometry));
  }
}

abstract class _DockedFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  const _DockedFloatingActionButtonLocation();

  @protected
  double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double appBarHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight / 2.0;
    if (snackBarHeight > 0.0)
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    if (appBarHeight > 0.0)
      fabY = math.min(fabY, contentBottom - appBarHeight - fabHeight / 2.0);

    final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return math.min(maxFabY, fabY);
  }
}
  static const FloatingActionButtonLocation centerDocked =
      _CenterDockedFloatingActionButtonLocation();
