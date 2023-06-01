import 'package:flutter/material.dart';
import 'package:recloset/Components/CheckboxInput.dart';
import 'package:recloset/Components/Header.dart';
import 'package:recloset/Components/NumberField.dart';
import 'package:recloset/Components/Subheader.dart';
import 'package:recloset/Types/CommonTypes.dart';

class FilterModal extends StatefulWidget {
  final Function(FilterState) onApply;
  FilterState filterState;
  final void Function() onClear;
  FilterModal(
      {super.key,
      required this.filterState,
      required this.onApply,
      required this.onClear});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  void toggleDealOption(bool isSelected, ItemDealOption dealOption) {
    if (isSelected) {
      setState(() {
        widget.filterState.dealOptions.add(dealOption);
      });
    } else {
      setState(() {
        widget.filterState.dealOptions.remove(dealOption);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 700,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            const Header(text: "Item Condition"),
            const Subheader(text: "Condition"),
            DropdownButton(
                isExpanded: true,
                value: widget.filterState.condition,
                items: ItemCondition.values
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option.displayName),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                      widget.filterState.condition = value;
                    })),
            const Header(text: "Price (in Credits)"),
            NumberField(
                initialValue: widget.filterState.minPrice != -1
                    ? widget.filterState.minPrice.toString()
                    : null,
                onChange: (newMinPrice) {
                  setState(() {
                    if (newMinPrice == '') {
                      widget.filterState.minPrice = -1;
                    } else {
                      widget.filterState.minPrice = int.parse(newMinPrice);
                    }
                  });
                },
                hintText: "Minimum"),
            NumberField(
                initialValue: widget.filterState.maxPrice != -1
                    ? widget.filterState.maxPrice.toString()
                    : null,
                onChange: (newMaxPrice) {
                  setState(() {
                    widget.filterState.maxPrice = int.parse(newMaxPrice);
                  });
                },
                hintText: "Maximum"),
            const Header(text: "Deal Option"),
            const Subheader(text: "Deal Option"),
            CheckboxInput(
                label: "Mailing & Delivery",
                onChange: (newValue) =>
                    toggleDealOption(newValue, ItemDealOption.delivery),
                isSelected: widget.filterState.dealOptions
                    .contains(ItemDealOption.delivery)),
            CheckboxInput(
              label: "Meet-up",
              onChange: (newValue) =>
                  toggleDealOption(newValue, ItemDealOption.meetup),
              isSelected: widget.filterState.dealOptions
                  .contains(ItemDealOption.meetup),
            ),
            // Create a slider for the distance to search
            const Subheader(text: "Distance"),
            // Create a label to display filterState.distance
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 2),
                child: Text("Maximum Distance: " +
                    widget.filterState.distance.toString().split(".")[0] +
                    " km"),
              ),
            ),
            Slider(
                value: widget.filterState.distance,
                min: 5,
                max: 100,
                divisions: 100,
                label: widget.filterState.distance.toString().split(".")[0] +
                    " km",
                onChanged: (value) {
                  setState(() {
                    widget.filterState.distance = value;
                  });
                }),
            SizedBox(
                width: 500,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 40)),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onApply(widget.filterState);
                        },
                        child: const Text("APPLY")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            fixedSize: const Size(100, 40)),
                        onPressed: () {
                          widget.onClear();
                          setState(() {
                            Navigator.pop(context);
                            widget.filterState = widget.filterState;
                          });
                        },
                        child: const Text("CLEAR"))
                  ],
                ))
          ],
        ));
  }
}
