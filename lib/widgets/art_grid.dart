import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_artist/widgets/pixel.dart';
import 'package:collection/collection.dart';

import '../helpers/fill_with_colour.dart';
import '../helpers/find_pixel_from_offset.dart';
import 'colour_palette.dart';

class ArtGrid extends StatefulWidget {
  const ArtGrid({
    super.key,
    this.gridSize = 25,
    this.pixelSize = 10,
  });

  final int gridSize;
  final int pixelSize;

  @override
  State<ArtGrid> createState() => _ArtGridState();
}

class _ArtGridState extends State<ArtGrid> {
  List<Color> pixelColours = [];
  List<List<Color>> history = [];
  int gridSize = 25;
  int pixelSize = 10;
  final int maxGridSize = 35;
  var colour = Colors.black;
  bool useFill = false;

  @override
  void initState() {
    super.initState();
    gridSize = widget.gridSize;
    pixelSize = widget.pixelSize;
    colour = Colors.black;

    _generateGrid();
  }

  void _updatePixel(Offset localPosition) {
    final pi = findPixelFromOffset(localPosition, gridSize, pixelSize);

    if (useFill) {
      pixelColours = fillWithColour(colour, pixelColours, gridSize, pi, pixelColours[pi]);
    } else {
      // Recreate whole List to make sure the change is visible
      pixelColours = List<Color>.generate(
          gridSize * gridSize, (i) => i == pi ? colour: pixelColours[i]
      );
    }

    setState(() {});
  }

  void _setColour(Color newColour) {
    if (colour == newColour) {
      return;
    }

    colour = newColour;

    setState(() {});
  }

  final deepEquality = DeepCollectionEquality();
  void _updateHistory() {
    if (deepEquality.equals(pixelColours, history.last)) {
      // No change, no need to update history
      return;
    }

    history.add(pixelColours);
  }

  void _flipCanvas() {
    pixelColours = pixelColours
        .slices(gridSize)
        .map((row) => row.reversed.toList())
        .expand((item) => item).toList();

    _updateHistory();

    setState(() {});
  }

  void _undoChange() {
    if (history.length == 1) {
      return;
    }

    history.removeLast();
    pixelColours = history.last;
    setState(() {});
  }

  void _generateGrid() {
    pixelColours = List<Color>.generate(
        gridSize * gridSize, (i) => Colors.transparent
    );

    history = [pixelColours];

    setState(() {});
  }

  void _resetGrid() {
    pixelColours = history.first;

    _updateHistory();
    setState(() {});
  }

  void _setGridSize(String val) {
    int newGridSize = int.tryParse(val) ?? gridSize;

    if (newGridSize > maxGridSize) {
      return;
    }

    setState(() {
      gridSize = newGridSize;
    });
     _generateGrid();
  }

  void _fillArea(Offset localPosition) {
    if (useFill == false) {
      return;
    }

  }

  void _toggleFill() {
    useFill = !useFill;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300, minWidth: 300),
          child: ColourPalette(
            colour: colour,
            callback: _setColour,
          ),
        ),
        Container(
          width: 200,
          margin: EdgeInsets.all(20),
          child: TextField(
            controller: TextEditingController(text: gridSize.toString()),
            onChanged: _setGridSize,
            decoration: InputDecoration(labelText: 'Enter grid size (max $maxGridSize)'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
          ),
        ),
      GestureDetector(
        onPanStart: (e) => _updatePixel(e.localPosition),
        onPanUpdate: (e) => _updatePixel(e.localPosition),
        onPanEnd: (e) => _updateHistory(),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: (gridSize * pixelSize).toDouble()),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  width: 5,
                  strokeAlign: BorderSide.strokeAlignOutside
              )
            ),
            child: Wrap(
              spacing: 0,
              runSpacing: 0,
              children: List<Pixel>.generate(
                gridSize * gridSize, (i) => Pixel(
                  color: pixelColours[i],
                  size: pixelSize,
                )
              ),
            ),
          )
        )
      ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _undoChange,
                child: Text('Undo'),
              ),
              TextButton(
                onPressed: _flipCanvas,
                child: Text('Flip canvas'),
              ),
              TextButton(
                onPressed: _toggleFill,
                child: Text('[${useFill ? 'X' : ' '}] Fill'),
              ),
              TextButton(
                onPressed: _resetGrid,
                child: Text('Reset'),
              ),
            ],
          ),
        )
      ],
    );
  }
}

