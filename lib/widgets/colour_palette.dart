import 'package:flutter/material.dart';

import '../constants/colour_palettes.dart';

class ColourPalette extends StatefulWidget {
  const ColourPalette(
      {super.key, required this.colour, required this.callback});

  final Color colour;
  final Function(Color) callback;

  @override
  State<ColourPalette> createState() => _ColourPaletteState();
}

class _ColourPaletteState extends State<ColourPalette> {
  final palette = nesPalette;
  final double pickerSize = 20;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: [
        ...List<GestureDetector>.generate(
          palette.length,
          (i) => GestureDetector(
            onTap: () => widget.callback(palette[i]),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: palette[i],
                boxShadow: palette[i] == widget.colour
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(1, 1),
                        ),
                        BoxShadow(
                          color: palette[i],
                          spreadRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1, 1),
                        )
                      ],
              ),
              height: pickerSize,
              width: pickerSize,
            ),
          ),
        ),
      ],
    );
  }
}
