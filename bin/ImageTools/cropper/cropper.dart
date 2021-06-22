import 'package:image/image.dart';

import 'CropBox.dart';
import 'cropBoxGenerator.dart';

Image getCropped(Image image) {
  CropBox cropBox = getCropBox(image);
  Image croppedImage =
      copyCrop(image, cropBox.x, cropBox.y, cropBox.width, cropBox.height);

  return croppedImage;
}
