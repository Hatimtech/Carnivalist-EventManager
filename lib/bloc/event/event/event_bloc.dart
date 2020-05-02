import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_main.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';

class EventBloc extends Bloc<EventMain, EventState> {
  final ApiProvider apiProvider = ApiProvider();

  @override
  EventState get initialState => EventState.initial();

  @override
  Stream<EventState> mapEventToState(EventMain event) async* {}
}
