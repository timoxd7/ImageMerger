/*
  Bounding Box in YOLOv4 Style:
  <object-class> <x_center> <y_center> <width> <height>

  Where object-class is the class (not in this file) and the rest is a float
  value relative to the image [0.0 to 1.0]
*/

import 'Rectangular.dart';

class BoundingBox {
  int objectClass;
  double x = 0, y = 0, width = 0, height = 0;

  BoundingBox(this.objectClass, this.x, this.y, this.width, this.height);

  /// destX: the x-position of the placed Image on the destination image
  /// destY: the y-position of the placed Image on the destination image
  /// destWidth: width of the destination image
  /// destHeight: height of the destination image
  /// srcWidth: the width of the placed image
  /// srcHeight: the height of the placed image
  BoundingBox.fromPlacedImage(this.objectClass, int destX, int destY,
      int destWidth, int destHeight, int srcWidth, int srcHeight) {
    double middleX = destX + (srcWidth / 2.0);
    double middleY = destY + (srcHeight / 2.0);

    x = middleX / destWidth;
    y = middleY / destHeight;

    width = srcWidth / destWidth;
    height = srcHeight / destHeight;
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();

    buffer.writeAll(<String>[
      objectClass.toString(),
      x.toString(),
      y.toString(),
      width.toString(),
      height.toString(),
    ], ' ');

    return buffer.toString();
  }

  Rectangular getRect(int imageWidth, int imageHeight) {
    double imageWidthDouble = imageWidth.toDouble();
    double imageHeightDouble = imageHeight.toDouble();

    int widthAbs = (imageWidthDouble * width).toInt();
    int heightAbs = (imageHeightDouble * height).toInt();

    int xAbs = (imageWidthDouble * x).toInt() - widthAbs ~/ 2;
    int yAbs = (imageHeightDouble * y).toInt() - heightAbs ~/ 2;

    return Rectangular(xAbs, yAbs, widthAbs, heightAbs);
  }
}
