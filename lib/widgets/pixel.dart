import 'package:flutter/material.dart';

class Pixel extends StatefulWidget {
  Color color;
  double size;

  Pixel({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<Pixel> createState() => _PixelState();
}

class _PixelState extends State<Pixel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      color: widget.color,
      height: widget.size,
      width: widget.size,
    );
  }
}

