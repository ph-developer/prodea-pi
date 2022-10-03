import '../../services/navigation_service.dart';

class GoBack {
  final INavigationService _navigationService;

  GoBack(this._navigationService);

  void call() {
    _navigationService.goBack();
  }
}
