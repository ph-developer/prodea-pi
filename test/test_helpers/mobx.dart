import 'package:mobx/mobx.dart';
import 'package:mocktail/mocktail.dart';

abstract class Callable<T> {
  void call([T? arg]) {}
}

class MockCallable<T> extends Mock implements Callable<T> {}

const whenReaction = reaction;
