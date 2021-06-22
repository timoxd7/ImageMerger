import 'package:image/image.dart';

import 'CropBox.dart';

const int alphaThreshhold = 245;
const int alphaThreshholdPixelCount = 3;

CropBox getCropBox(Image image) {
  int xOffset = getXOffset(image);
  int yOffset = getYOffset(image);
  int xMaxOffset = getXMaxOffset(image);
  int yMaxOffset = getYMaxOffset(image);

  int width = image.width - xMaxOffset - xOffset;
  int height = image.height - yMaxOffset - yOffset;

  return CropBox(xOffset, yOffset, width, height);
}

int getXOffset(Image image) {
  for (int x = 0; x < image.width; x++) {
    int amountOverThreshhold = 0;

    for (int y = 0; y < image.height; y++) {
      if (getAlpha(image.getPixel(x, y)) > alphaThreshhold) {
        amountOverThreshhold++;
      }

      if (amountOverThreshhold >= alphaThreshholdPixelCount) {
        return x;
      }
    }
  }

  return 0;
}

int getYOffset(Image image) {
  for (int y = 0; y < image.height; y++) {
    int amountOverThreshhold = 0;

    for (int x = 0; x < image.width; x++) {
      if (getAlpha(image.getPixel(x, y)) > alphaThreshhold) {
        amountOverThreshhold++;
      }

      if (amountOverThreshhold >= alphaThreshholdPixelCount) {
        return y;
      }
    }
  }

  return 0;
}

int getXMaxOffset(Image image) {
  for (int x = 0; x < image.width; x++) {
    int amountOverThreshhold = 0;

    for (int y = 0; y < image.height; y++) {
      if (getAlpha(image.getPixel((image.width - 1) - x, y)) >
          alphaThreshhold) {
        amountOverThreshhold++;
      }

      if (amountOverThreshhold >= alphaThreshholdPixelCount) {
        return x;
      }
    }
  }

  return 0;
}

int getYMaxOffset(Image image) {
  for (int y = 0; y < image.height; y++) {
    int amountOverThreshhold = 0;

    for (int x = 0; x < image.width; x++) {
      if (getAlpha(image.getPixel(x, (image.height - 1) - y)) >
          alphaThreshhold) {
        amountOverThreshhold++;
      }

      if (amountOverThreshhold >= alphaThreshholdPixelCount) {
        return y;
      }
    }
  }

  return 0;
}
