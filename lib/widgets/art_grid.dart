import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_artist/widgets/pixel.dart';
import 'package:collection/collection.dart';

import 'colour_palette.dart';

class ArtGrid extends StatefulWidget {
  const ArtGrid({
    super.key,
    this.gridSize = 25,
    this.pixelSize = 10,
  });

  final int gridSize;
  final double pixelSize;

  @override
  State<ArtGrid> createState() => _ArtGridState();
}

class _ArtGridState extends State<ArtGrid> {
  List<Color> pixelColours = [];
  List<List<Color>> history = [];
  int gridSize = 25;
  double pixelSize = 10;
  final int maxGridSize = 35;
  var colour = Colors.black;

  @override
  void initState() {
    super.initState();
    gridSize = widget.gridSize;
    pixelSize = widget.pixelSize;
    colour = Colors.black;

    _generateGrid();
  }

  void _updatePixel(Offset localPosition, [bool start = false]) {
    double dx = localPosition.dx;
    double dy = localPosition.dy;

    // Make sure we're inside the drawing area
    if (dx <= 0 || dy <= 0 || dx >= gridSize * pixelSize || dy >= gridSize * pixelSize) {
      return;
    }

    // Find out which pixel was panned over
    int xi = (dx / pixelSize).truncate();
    int yi = (dy / pixelSize).truncate();
    int pi = xi + (yi * gridSize);

    // Recreate whole List to make sure the change is visible
    pixelColours = List<Color>.generate(
      gridSize * gridSize, (i) => i == pi ? colour: pixelColours[i]
    );

    setState(() {});
  }

  void _setColour(Color newColour) {
    if (colour == newColour) {
      return;
    }

    colour = newColour;

    setState(() {});
  }

  void _flipCanvas() {
    pixelColours = pixelColours
      .slices(gridSize)
      .map((row) => row.reversed.toList())
      .expand((item) => item).toList();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: gridSize * pixelSize),
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
        onPanStart: (e) => _updatePixel(e.localPosition, true),
        onPanUpdate: (e) => _updatePixel(e.localPosition),
        onPanEnd: (e) => _updateHistory(),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: gridSize * pixelSize),
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
        TextButton(
          onPressed: _undoChange,
          child: Text('Undo change (${history.length - 1})'),
        ),
        TextButton(
          onPressed: _flipCanvas,
          child: Text('Flip canvas horizontally'),
        ),
        TextButton(
          onPressed: _generateGrid,
          child: Text('Reset grid'),
        ),
      ],
    );
  }
}

