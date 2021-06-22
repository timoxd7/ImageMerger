import 'package:image/image.dart';

Image copyMirror(Image src) {
  Image mirrorImage = Image(src.width, src.height);

  for (int x = 0; x < src.width; x++) {
    int otherX = (src.width - 1) - x;
    for (int y = 0; y < src.height; y++) {
      mirrorImage.setPixel(x, y, src.getPixel(otherX, y));
    }
  }

  return mirrorImage;
}
