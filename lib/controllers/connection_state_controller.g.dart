// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_state_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConnectionStateController on _ConnectionStateControllerBase, Store {
  late final _$isConnectedAtom = Atom(
      name: '_ConnectionStateControllerBase.isConnected', context: context);

  @override
  bool get isConnected {
    _$isConnectedAtom.reportRead();
    return super.isConnected;
  }

  @override
  set isConnected(bool value) {
    _$isConnectedAtom.reportWrite(value, super.isConnected, () {
      super.isConnected = value;
    });
  }

  @override
  String toString() {
    return '''
isConnected: ${isConnected}
    ''';
  }
}
