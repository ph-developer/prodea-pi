import 'package:prodea/routes.dart';
import 'package:prodea/services/contracts/navigation_service.dart';
import 'package:seafarer/seafarer.dart';

class SeafarerNavigationService implements INavigationService {
  final Seafarer seafarer;

  SeafarerNavigationService(
    this.seafarer,
  );

  @override
  void navigate(
    String route, {
    bool replace = false,
    Map<String, dynamic>? params,
  }) {
    Routes.seafarer.navigate(
      route,
      navigationType:
          replace ? NavigationType.pushAndRemoveUntil : NavigationType.push,
      removeUntilPredicate: replace ? (r) => false : null,
      params: params,
    );
  }

  @override
  void back() {
    Routes.seafarer.pop();
  }
}
