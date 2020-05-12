abstract class PageNavEvent {}

class CurrentPageInput extends PageNavEvent {
  final int page;

  CurrentPageInput(this.page);
}
