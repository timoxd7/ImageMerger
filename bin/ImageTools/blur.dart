import 'dart:math';

import 'package:image/image.dart';

const int maxBlurRadius = 8;

void addBlur(Random random, Image image) {
  int blurRadius = random.nextInt(maxBlurRadius);

  if (blurRadius >= image.width || blurRadius >= image.height) {
    blurRadius = min(image.width, image.height) ~/ 2;
  }

  gaussianBlur(image, blurRadius);
}
