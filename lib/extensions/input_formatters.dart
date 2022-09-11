import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final dateMaskInputFormatter = MaskTextInputFormatter(
  mask: '99/99/9999',
);
final cnpjMaskInputFormatter = MaskTextInputFormatter(
  mask: '99.999.999/9999-99',
);
final cpfMaskInputFormatter = MaskTextInputFormatter(
  mask: '999.999.999-99',
);

class PhoneMaskInputFormatter extends MaskTextInputFormatter {
  static const String _landlineMask = "(99) 9999-9999";
  static const String _phoneMask = "(99) 99999-9999";

  PhoneMaskInputFormatter()
      : super(
          mask: _landlineMask,
          filter: {"9": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy,
        );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String? mask = getMask();
    if (oldValue.text.isNotEmpty) {
      final String numbers = newValue.text.replaceAll(RegExp("[^0-9]"), "");
      if (numbers.length <= 10) {
        if (mask != _landlineMask) updateMask(mask: _landlineMask);
      } else {
        if (mask != _phoneMask) updateMask(mask: _phoneMask);
      }
    }
    return super.formatEditUpdate(oldValue, newValue);
  }
}
