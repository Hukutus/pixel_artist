import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_artist/widgets/pixel.dart';

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
  List<Pixel> pixels = [];
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

  void _updatePixel(Offset localPosition) {
    double dx = localPosition.dx;
    double dy = localPosition.dy;

    if (dx <= 0 || dy <= 0 || dx >= gridSize * pixelSize || dy >= gridSize * pixelSize) {
      // Outside of drawing area
      return;
    }

    int xi = (dx / pixelSize).truncate();
    int yi = (dy / pixelSize).truncate();
    int pi = xi + (yi * gridSize);

    pixels = List<Pixel>.generate(
      gridSize * gridSize, (i) => Pixel(
        color: i == pi ? colour: pixels[i].color,
        size: pixelSize,
      ),
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

  void _generateGrid() {
    pixels = List<Pixel>.generate(
      gridSize * gridSize, (i) => Pixel(
        color: Colors.transparent,
        size: pixelSize,
      ),
    );

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
        onPanStart: (e) => _updatePixel(e.localPosition),
        onPanUpdate: (e) => _updatePixel(e.localPosition),
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
              children: pixels,
            ),
          )
        )
      ),
        TextButton(
          onPressed: _generateGrid,
          child: Text('Reset grid'),
        ),
      ],
    );
  }
}

