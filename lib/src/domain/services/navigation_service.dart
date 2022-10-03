abstract class INavigationService {
  void goTo(String path, {bool replace = false});
  void goBack();
  Stream<String> currentRoute();
}
