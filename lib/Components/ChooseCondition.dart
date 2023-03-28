import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Data/ListingProvider.dart';

// TODO: don't repeat this, put into contructor.
const List<String> conditionList = <String>[
  'Brand new',
  'Like new',
  'Lightly used',
  'Well used',
  'Heavily used'
];

class ChooseCondition extends StatefulWidget {
  final List<String> items;

  const ChooseCondition({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<ChooseCondition> createState() => _ChooseConditionState();
}

class _ChooseConditionState extends State<ChooseCondition> {
  String dropdownValue = conditionList.first;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 220, 220, 220),
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          style: const TextStyle(color: Colors.black),
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
              Provider.of<ListingProvider>(context, listen: false).condition =
                  value;
            });
          },
          items:
              this.widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
  }
}
