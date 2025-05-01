import 'package:flutter/material.dart';

class ToggleselectablesSquares extends StatefulWidget {
  final List<String> squares;
  final Function(List<String>) onSelect;
  final Map<String, Color> squareColors;

  const ToggleselectablesSquares({
    Key? key,
    required this.squares,
    required this.onSelect,
    required this.squareColors,
  }) : super(key: key);

  @override
  _ToggleselectablesSquaresState createState() =>
      _ToggleselectablesSquaresState();
}

class _ToggleselectablesSquaresState extends State<ToggleselectablesSquares> {
  List<String> selectedSquares = [];

  @override
  void initState() {
    super.initState();
    selectedSquares = [widget.squares.first];
  }

  void _toggleSelection(String square) {
    setState(() {
      if (selectedSquares.contains(square)) {
        // If the square is already selected, deselect it

        selectedSquares.remove(square);
      } else {
        // If the square is not selected, select it
        selectedSquares = [square];
      }
    });
    widget.onSelect(selectedSquares);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.squares.map((square) {
        final borderColor = widget.squareColors.containsKey(square)
            ? widget.squareColors[square]
            : Colors.transparent;
        final isSelected = selectedSquares.contains(square);

        return GestureDetector(
          onTap: () => _toggleSelection(square),
          child: Container(
            margin: EdgeInsets.all(8.0),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? borderColor : Colors.grey,
              border: Border.all(color: borderColor!, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: Text(
              square,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
