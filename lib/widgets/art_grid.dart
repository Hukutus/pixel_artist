import 'package:flutter/material.dart';
import 'package:pixel_artist/widgets/pixel.dart';

class ArtGrid extends StatefulWidget {
  const ArtGrid({
    super.key,
    this.width = 16,
    this.height = 16,
  });

  final int width;
  final int height;

  @override
  ArtGridState createState() => ArtGridState();
}

class ArtGridState extends State<ArtGrid> {
  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;

    _generateGrid();
  }

  void _generateGrid() {
    print('Generate grid');

    List<Pixel> pixelRow = List<Pixel>.generate(
      width, (i) => Pixel(
      color: Colors.red,
    ),
    );

    pixels = List<Row>.generate(
      height, (i) => Row(
      children: pixelRow,
    ),
    );
  }

  void _recolorRow() {
    List<Pixel> pixelRowRecolor = List<Pixel>.generate(
      width, (i) => Pixel(
      color: Colors.blue,
    ),
    );

    pixels[0] = Row(
      children: pixelRowRecolor,
    );

    print(pixels[0].children[0]);
  }

  List<Row> pixels = [];
  int width = 16;
  int height = 16;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Grid size: ${height}x$width'
        ),
        TextButton(
          onPressed: _recolorRow,
          child: Text('Reset grid'),
        ),
        Column(
          children: pixels,
        ),
      ],
    );
  }
}

