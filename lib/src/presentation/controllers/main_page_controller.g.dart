// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_page_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainPageController on _MainPageControllerBase, Store {
  Computed<PageInfo?>? _$currentPageInfoComputed;

  @override
  PageInfo? get currentPageInfo => (_$currentPageInfoComputed ??=
          Computed<PageInfo?>(() => super.currentPageInfo,
              name: '_MainPageControllerBase.currentPageInfo'))
      .value;

  late final _$pageInfosAtom =
      Atom(name: '_MainPageControllerBase.pageInfos', context: context);

  @override
  ObservableList<PageInfo> get pageInfos {
    _$pageInfosAtom.reportRead();
    return super.pageInfos;
  }

  @override
  set pageInfos(ObservableList<PageInfo> value) {
    _$pageInfosAtom.reportWrite(value, super.pageInfos, () {
      super.pageInfos = value;
    });
  }

  late final _$currentPageIndexAtom =
      Atom(name: '_MainPageControllerBase.currentPageIndex', context: context);

  @override
  int get currentPageIndex {
    _$currentPageIndexAtom.reportRead();
    return super.currentPageIndex;
  }

  @override
  set currentPageIndex(int value) {
    _$currentPageIndexAtom.reportWrite(value, super.currentPageIndex, () {
      super.currentPageIndex = value;
    });
  }

  late final _$_MainPageControllerBaseActionController =
      ActionController(name: '_MainPageControllerBase', context: context);

  @override
  void init() {
    final _$actionInfo = _$_MainPageControllerBaseActionController.startAction(
        name: '_MainPageControllerBase.init');
    try {
      return super.init();
    } finally {
      _$_MainPageControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToPage(int pageIndex) {
    final _$actionInfo = _$_MainPageControllerBaseActionController.startAction(
        name: '_MainPageControllerBase.navigateToPage');
    try {
      return super.navigateToPage(pageIndex);
    } finally {
      _$_MainPageControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageInfos: ${pageInfos},
currentPageIndex: ${currentPageIndex},
currentPageInfo: ${currentPageInfo}
    ''';
  }
}
