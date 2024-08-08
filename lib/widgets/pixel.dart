import 'package:flutter/material.dart';

class Pixel extends StatefulWidget {
  Pixel({
    super.key,
    this.color = Colors.white,
  });

  Color color;

  @override
  PixelState createState() => PixelState();
}

class PixelState extends State<Pixel> {
  @override
  void initState() {
    super.initState();
  }

  void _setColor(PointerEvent event) {
    setState(() {
      widget.color = Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _setColor,
      child: Container(
          margin: const EdgeInsets.all(0),
          color: widget.color,
          height: 10,
          width: 10,
      ),
    );
  }
}

