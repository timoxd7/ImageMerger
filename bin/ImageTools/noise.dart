import 'dart:math';

import 'package:image/image.dart';

const int maxNoiseStrength = 255;

void addNoise(Random random, Image image) {
  int noiseStrength = random.nextInt(maxNoiseStrength);

  if (noiseStrength > 0) {
    for (int i = 0; i < image.data.length; i++) {
      int color = image.data[i];

      int red = getRed(color);
      int green = getGreen(color);
      int blue = getBlue(color);

      int redNoise = random.nextInt(noiseStrength);
      red += (redNoise - (redNoise ~/ 2));
      if (red > 255) {
        red = 255;
      } else if (red < 0) {
        red = 0;
      }

      int greenNoise = random.nextInt(noiseStrength);
      greenNoise += (greenNoise - (greenNoise ~/ 2));
      if (green > 255) {
        green = 255;
      } else if (green < 0) {
        green = 0;
      }

      int blueNoise = random.nextInt(noiseStrength);
      blue += (blueNoise - (blueNoise ~/ 2));
      if (blue > 255) {
        blue = 255;
      } else if (blue < 0) {
        blue = 0;
      }

      color = setRed(color, red);
      color = setGreen(color, green);
      color = setBlue(color, blue);

      image.data[i] = color;
    }
  }
}
