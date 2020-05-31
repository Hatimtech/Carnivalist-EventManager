import 'package:eventmanagement/utils/vars.dart';

class PageNavState {
  int page;

  PageNavState({
    this.page,
  });

  factory PageNavState.initial() {
    return PageNavState(
      page: PAGE_DASHBOARD,
    );
  }

  PageNavState copyWith({
    int page,
  }) {
    return PageNavState(
      page: page ?? this.page,
    );
  }
}
