abstract class INavigationService {
  void navigate(String route, {bool replace = false});
  void back();
}
