import 'package:diacritic/diacritic.dart';

extension StringExtension on String {
  bool includes(String text) {
    final normalizedString = removeDiacritics(this).toLowerCase();
    final normalizedText = removeDiacritics(text).toLowerCase();

    return normalizedString.contains(normalizedText);
  }

  bool isAValidDate() {
    final splitted = split('/');
    if (splitted.length != 3) return false;

    final day = int.tryParse(splitted[0]);
    if (day == null || day < 1 || day > 31) return false;

    final month = int.tryParse(splitted[1]);
    if (month == null || month < 1 || month > 12) return false;

    final year = int.tryParse(splitted[2]);
    if (year == null || year < 2022) return false;

    return true;
  }
}
