import 'package:flutter/material.dart';

class CheckboxInput extends StatefulWidget {
  final String label;

  final Function(bool) onChange;
  const CheckboxInput({super.key, required this.label, required this.onChange});

  @override
  State<CheckboxInput> createState() => _CheckboxInputState();
}

class _CheckboxInputState extends State<CheckboxInput> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          value: _isSelected,
          onChanged: (newValue) {
            if (newValue != null) {
              widget.onChange(newValue);
              setState(() {
                _isSelected = newValue;
              });
            }
          }),
      Text(widget.label)
    ]);
  }
}
