import 'dart:math';

class Rectangular {
  final int x, y, width, height;
  Rectangular(this.x, this.y, this.width, this.height);

  double getIntersectArea(Rectangular other) {
    Rectangle thisRect = Rectangle(x, y, width, height);
    Rectangle otherRect =
        Rectangle(other.x, other.y, other.width, other.height);

    Rectangle intersectAreaRect = thisRect.intersection(otherRect);

    if (intersectAreaRect == null) return 0.0;

    double thisArea = (width * height).toDouble();
    double otherArea = (other.width * other.height).toDouble();
    double intersectArea =
        (intersectAreaRect.width * intersectAreaRect.height).toDouble();

    return max(intersectArea / thisArea, intersectArea / otherArea);
  }
}
