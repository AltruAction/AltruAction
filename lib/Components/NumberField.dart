import 'package:flutter/material.dart';

class NumberField extends StatelessWidget {
  final String? initialValue;
  final String hintText;
  final Function(String) onChange;
  const NumberField(
      {super.key,
      required this.initialValue,
      required this.onChange,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: initialValue,
        onChanged: onChange,
        decoration: InputDecoration(hintText: hintText),
        keyboardType: const TextInputType.numberWithOptions(
            decimal: false, signed: false));
  }
}
