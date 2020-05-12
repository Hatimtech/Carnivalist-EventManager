class PageNavState {
  int page;

  PageNavState({
    this.page,
  });

  factory PageNavState.initial() {
    return PageNavState(
      page: 0,
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
