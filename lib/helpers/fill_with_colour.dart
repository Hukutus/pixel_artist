import 'dart:ui';

bool _isInBounds(int i1, int i2, int size) {
  return i2 < size * size && i2 >= 0;
}

bool _isHorizontallyAdjacent(int i1, int i2, int size) {
  return _isInBounds(i1, i2, size) && (i1 / size).floor() == (i2 / size).floor();
}

bool _isFillable(Color color1, Color color2) {
  return color1 == color2;
}

List<int> _getFillableAdjacentPixels(int pi, int gridSize, initialColour, pixelColours) {
  List<int> adjacentPixels = [];

  final int iLeft = pi - 1;
  if (_isHorizontallyAdjacent(pi, iLeft, gridSize) && _isFillable(initialColour, pixelColours[iLeft])) {
    adjacentPixels.add(iLeft);
  }

  final int iRight = pi + 1;
  if (_isHorizontallyAdjacent(pi, iRight, gridSize) && _isFillable(initialColour, pixelColours[iRight])) {
    adjacentPixels.add(iRight);
  }

  final int iAbove = pi - gridSize;
  if (_isInBounds(pi, iAbove, gridSize) && _isFillable(initialColour, pixelColours[iAbove])) {
    adjacentPixels.add(iAbove);
  }

  final int iBelow = pi + gridSize;
  if (_isInBounds(pi, iBelow, gridSize) && _isFillable(initialColour, pixelColours[iBelow])) {
    adjacentPixels.add(iBelow);
  }

  return adjacentPixels;
}

List<Color> fillWithColour(Color fillColour, List<Color> pixelColours, int gridSize, int pi, [Color? initialColourProp]) {
  /*
    To fill an area, we need to check if the adjacent pixels ar
      1) A valid index
      2) Have the same colour

    We then have to repeat the process on adjacent pixels of adjacent pixels
    until no more valid pixels are found

    Example:
    □ □ ■ □ □       ■ ■ ■ □ □
    □ ▣ □ ■ □  ->   ■ ■ ■ ■ □
    □ □ ■ □ □       ■ ■ ■ □ □

  */

  final initialColour = initialColourProp ?? pixelColours[pi];

  if (fillColour == initialColour) {
    // Already filled
    return pixelColours;
  }

  var filledColours = [...pixelColours];

  // Fill current pixel
  filledColours[pi] = fillColour;

  // Get valid adjacent pixels
  final adjacentPixels = _getFillableAdjacentPixels(pi, gridSize, initialColour, pixelColours);

  // Fill adjacent pixels
  // Recursion for adjacent pixels of adjacent pixels
  for (var ai in adjacentPixels) {
    filledColours[ai] = fillColour;
    filledColours = fillWithColour(fillColour, filledColours, gridSize, ai, initialColour);
  }

  return filledColours;
}
