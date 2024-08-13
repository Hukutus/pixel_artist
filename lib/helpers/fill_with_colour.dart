import 'dart:ui';

bool _pixelIsValid(int size, bool row, int i1, int i2, Color color1, List<Color> pixelColours) {
  if (i2 > (size * size - 1) || i2 < 0) {
    // Index out of bound
    return false;
  }

  if (row && (i1 / size).floor() != (i2 / size).floor()) {
    // Different row, don't fill
    return false;
  }

  if (color1 != pixelColours[i2]) {
    // Different colour, don't fill
    return false;
  }

  return true;
}

List<Color> fillWithColour(Color colour, List<Color> pixelColours, int gridSize, int pi, Color initialColor) {
  /*
    To fill an area, we need to check if the pixels next to
    the pixel that was pressed have the same color, and if so color them,
    and repeat the process until no valid pixels are found

    Example:
    □ □ ■ □ □       ■ ■ ■ □ □
    □ ▣ □ ■ □  ->   ■ ■ ■ ■ □
    □ □ ■ □ □       ■ ■ ■ □ □

  */

  if (colour == initialColor) {
    // Already filled
    return pixelColours;
  }

  // Color pressed pixel
  pixelColours[pi] = colour;

  // The following logic could be cleaned up, but it works
  // Color each adjacent pixel if it's valid

  final int iLeft = pi - 1;
  if (_pixelIsValid(gridSize, true, pi, iLeft, initialColor, pixelColours)) {
    pixelColours[iLeft] = colour;

    pixelColours = fillWithColour(colour, pixelColours, gridSize, iLeft, initialColor);
  }

  final int iRight = pi + 1;
  if (_pixelIsValid(gridSize, true, pi, iRight, initialColor, pixelColours)) {
    pixelColours[iRight] = colour;

    pixelColours = fillWithColour(colour, pixelColours, gridSize, iRight, initialColor);
  }

  final int iAbove = pi - gridSize;
  if (_pixelIsValid(gridSize, false, pi, iAbove, initialColor, pixelColours)) {
    pixelColours[iAbove] = colour;

    pixelColours = fillWithColour(colour, pixelColours, gridSize, iAbove, initialColor);
  }

  final int iBelow = pi + gridSize;
  if (_pixelIsValid(gridSize, false, pi, iBelow, initialColor, pixelColours)) {
    pixelColours[iBelow] = colour;

    pixelColours = fillWithColour(colour, pixelColours, gridSize, iBelow, initialColor);
  }

  return List<Color>.generate(
      gridSize * gridSize, (i) => pixelColours[i]
  );
}
