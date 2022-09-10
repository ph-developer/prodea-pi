import 'package:prodea/routes.dart';
import 'package:prodea/services/contracts/navigation_service.dart';
import 'package:seafarer/seafarer.dart';

class SeafarerNavigationService implements INavigationService {
  @override
  void navigate(String route, {bool replace = false}) {
    Routes.seafarer.navigate(
      route,
      navigationType:
          replace ? NavigationType.pushAndRemoveUntil : NavigationType.push,
      removeUntilPredicate: replace ? (r) => false : null,
    );
  }

  @override
  void back() {
    Routes.seafarer.pop();
  }
}
