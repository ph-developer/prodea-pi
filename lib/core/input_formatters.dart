import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final dateMaskInputFormatter = MaskTextInputFormatter(
  mask: '##/##/####',
);
final cnpjMaskInputFormatter = MaskTextInputFormatter(
  mask: '##.###.###/####-##',
);
final cpfMaskInputFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
);

class PhoneMaskInputFormatter extends MaskTextInputFormatter {
  static const String _landlineMask = "(##) ####-####";
  static const String _phoneMask = "(##) #####-####";

  PhoneMaskInputFormatter()
      : super(
          mask: _landlineMask,
          filter: {"#": RegExp(r'[0-9]')},
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
