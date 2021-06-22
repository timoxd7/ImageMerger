import 'dart:math';

import 'package:image/image.dart';

import '../Database/RenderSettings.dart';
import 'copyMirror.dart';
import 'cropper/cropper.dart';
import 'noise.dart';

Image applyTransforms(Random random, Image image, RenderSettings settings) {
  // Mirror
  if (random.nextBool()) {
    image = copyMirror(image);
  }

  // Rotate
  image = copyRotate(image, random.nextInt(360));

  // Crop Boundaries
  image = getCropped(image);

  // Resize
  double newSize = settings.maxSize - settings.minSize;
  newSize *= random.nextDouble();
  newSize += settings.minSize;
  int newWidth = (newSize * image.width).toInt();
  image = copyResize(image, width: newWidth);

  // Noise
  addNoise(random, image);

  return image;
}
