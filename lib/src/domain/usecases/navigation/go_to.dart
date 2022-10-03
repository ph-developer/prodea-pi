import '../../services/navigation_service.dart';

class GoTo {
  final INavigationService _navigationService;

  GoTo(this._navigationService);

  void call(String path, {bool replace = false}) {
    _navigationService.goTo(path, replace: replace);
  }
}
