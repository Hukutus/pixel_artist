import 'dart:ui';

int findPixelFromOffset(Offset localPosition, int gridSize, int pixelSize) {
  double dx = localPosition.dx;
  double dy = localPosition.dy;

  // Make sure we're inside the drawing area
  if (dx <= 0 || dy <= 0 || dx >= gridSize * pixelSize || dy >= gridSize * pixelSize) {
    return -1;
  }

  // Find out which pixel was panned over
  int xi = (dx / pixelSize).truncate();
  int yi = (dy / pixelSize).truncate();
  int pi = xi + (yi * gridSize);

  return pi;
}
