import 'dart:async';

mixin StreamSubscriber {
  final List<StreamSubscription> _subscriptions = [];

  Future<void> subscribe<T>(
    Stream<T> stream,
    Function(T) onEvent,
  ) async {
    _subscriptions.add(stream.listen(onEvent));
  }

  Future<void> unsubscribeAll() async {
    _subscriptions.map((subscription) => subscription.cancel());
    _subscriptions.clear();
  }
}
