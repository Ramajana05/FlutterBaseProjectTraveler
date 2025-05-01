import 'package:flutter/material.dart';

class ToggleButtonRow extends StatefulWidget {
  final List<String> buttons;

  ToggleButtonRow({required this.buttons});

  @override
  _ToggleButtonRowState createState() => _ToggleButtonRowState();
}

class _ToggleButtonRowState extends State<ToggleButtonRow> {
  String? selectedButton;
  bool allButtonsVisible = false;

  @override
  void initState() {
    super.initState();
    selectedButton = widget.buttons.first;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonWidgets = [];
    if (allButtonsVisible) {
      buttonWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              allButtonsVisible = false;
            });
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              selectedButton ?? '',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }
    buttonWidgets.addAll(
      widget.buttons.map((button) {
        final isSelected = button == selectedButton;

        return Visibility(
          visible: allButtonsVisible || isSelected,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  allButtonsVisible = !allButtonsVisible;
                } else {
                  selectedButton = button;
                  allButtonsVisible = false;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                button,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

    return Row(children: buttonWidgets);
  }
}
