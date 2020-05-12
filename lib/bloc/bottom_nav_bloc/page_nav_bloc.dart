import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/bottom_nav_bloc/page_nav_event.dart';
import 'package:eventmanagement/bloc/bottom_nav_bloc/page_nav_state.dart';

class PageNavBloc extends Bloc<PageNavEvent, PageNavState> {
  void currentPage(int page) {
    add(CurrentPageInput(page));
  }

  @override
  PageNavState get initialState {
    return PageNavState.initial();
  }

  @override
  Stream<PageNavState> mapEventToState(PageNavEvent event) async* {
    if (event is CurrentPageInput) {
      yield state.copyWith(page: event.page);
    }
  }
}
