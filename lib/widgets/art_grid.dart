import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_artist/widgets/pixel.dart';

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

  @override
  void initState() {
    super.initState();
    gridSize = widget.gridSize;
    pixelSize = widget.pixelSize;

    _generateGrid();
  }

  void _setColor(Offset localPosition) {
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
        color: i == pi ? Colors.black: pixels[i].color,
        size: pixelSize,
      ),
    );

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
        Text(
          'Grid size: ${gridSize}x$gridSize',
        ),
      TextField(
        onChanged: _setGridSize,
        decoration: InputDecoration(labelText: 'Enter grid size (max $maxGridSize)'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
      ),
      GestureDetector(
        onPanStart: (e) => _setColor(e.localPosition),
        onPanUpdate: (e) => _setColor(e.localPosition),
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

