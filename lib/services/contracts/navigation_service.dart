abstract class INavigationService {
  void navigate(
    String route, {
    bool replace = false,
    Map<String, dynamic>? params,
  });
  void back();
}
