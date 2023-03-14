import 'package:flutter/material.dart';

class NumberField extends StatelessWidget {
  final String hintText;
  const NumberField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(hintText: hintText),
        keyboardType: const TextInputType.numberWithOptions(
            decimal: false, signed: false));
  }
}
