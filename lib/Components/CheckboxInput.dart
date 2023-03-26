import 'package:flutter/material.dart';

class CheckboxInput extends StatefulWidget {
  final String label;
  final bool isSelected;

  final Function(bool) onChange;
  const CheckboxInput(
      {super.key,
      required this.label,
      required this.onChange,
      required this.isSelected});

  @override
  State<CheckboxInput> createState() => _CheckboxInputState();
}

class _CheckboxInputState extends State<CheckboxInput> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          value: widget.isSelected,
          onChanged: (newValue) {
            if (newValue != null) {
              widget.onChange(newValue);
            }
          }),
      Text(widget.label)
    ]);
  }
}
