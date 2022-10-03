import '../../services/navigation_service.dart';

class GetCurrentRoute {
  final INavigationService _navigationService;

  GetCurrentRoute(this._navigationService);

  Stream<String> call() {
    return _navigationService.currentRoute();
  }
}
