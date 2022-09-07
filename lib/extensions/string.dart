import 'package:diacritic/diacritic.dart';

extension StringExtension on String {
  bool includes(String text) {
    final normalizedString = removeDiacritics(this).toLowerCase();
    final normalizedText = removeDiacritics(text).toLowerCase();

    return normalizedString.contains(normalizedText);
  }
}
