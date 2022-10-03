import 'package:flutter/material.dart';

class LoadingOutlinedButton extends StatelessWidget {
  const LoadingOutlinedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OutlinedButton(
      onPressed: null,
      child: SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
