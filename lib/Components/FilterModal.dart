import 'package:flutter/material.dart';
import 'package:recloset/Components/CheckboxInput.dart';
import 'package:recloset/Components/Header.dart';
import 'package:recloset/Components/NumberField.dart';
import 'package:recloset/Components/Subheader.dart';
import 'package:recloset/Types/CommonTypes.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late ItemCondition? condition = ItemCondition.none;
  late int? minPrice;
  late int? maxPrice;
  List<ItemDealOption> dealOptions = [];

  void toggleDealOption(bool isSelected, ItemDealOption dealOption) {
    if (isSelected) {
      dealOptions.add(dealOption);
    } else {
      dealOptions.remove(dealOption);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Header(text: "Item Condition"),
            const Subheader(text: "Condition"),
            DropdownButton(
                isExpanded: true,
                value: condition,
                items: ItemCondition.values
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                      condition = value;
                    })),
            const Header(text: "Price (in Credits)"),
            const NumberField(hintText: "Minimum"),
            const NumberField(hintText: "Maximum"),
            const Header(text: "Deal Option"),
            const Subheader(text: "Deal Option"),
            CheckboxInput(
                label: "Mailing & Delivery",
                onChange: (newValue) =>
                    toggleDealOption(newValue, ItemDealOption.delivery)),
            CheckboxInput(
                label: "Meet-up",
                onChange: (newValue) =>
                    toggleDealOption(newValue, ItemDealOption.meetup))
          ],
        ));
  }
}
