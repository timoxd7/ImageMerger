import 'dart:io';

import 'package:image/image.dart';
import 'package:path/path.dart' as path;

import 'Database/BoundingBox.dart';
import 'Database/Rectangular.dart';
import 'Database/RenderedImage.dart';

const int rectLineCount = 4;

List<int> colors = <int>[
  Color.fromRgb(255, 131, 0),
  Color.fromRgb(0, 0, 255),
  Color.fromRgb(0, 255, 0),
  Color.fromRgb(255, 255, 0),
  Color.fromRgb(255, 0, 0),
];

int _nameCounter = 0;
bool _counterSet = false;
void exporter(Directory outputDir, RenderedImage renderedImage,
    bool outputLabeled, int countOffset) {
  if (!_counterSet) {
    _counterSet = true;
    _nameCounter = countOffset;
  }

  File outputFileImage =
      File(path.join(outputDir.path, _nameCounter.toString() + '.jpg'));
  File outputFileBoxInfo =
      File(path.join(outputDir.path, _nameCounter.toString() + '.txt'));

  outputFileImage.writeAsBytesSync(encodeJpg(renderedImage.image));

  StringBuffer boxInfoBuffer = StringBuffer();
  for (BoundingBox boundingBox in renderedImage.boxes) {
    boxInfoBuffer.writeAll(<String>[boundingBox.toString(), '\n']);
  }

  outputFileBoxInfo.writeAsStringSync(boxInfoBuffer.toString());

  if (outputLabeled) {
    exportLabeled(outputDir, renderedImage);
  }

  _nameCounter++;
}

void exportLabeled(Directory outputDir, RenderedImage renderedImage) {
  Directory labeledOutputDir = Directory(path.join(outputDir.path, 'labeled'));
  labeledOutputDir.create();

  File outputFileImage = File(path.join(
      labeledOutputDir.path, _nameCounter.toString() + '-labeled.jpg'));

  Image outputImage = copyCrop(renderedImage.image, 0, 0,
      renderedImage.image.width, renderedImage.image.height);

  // Render boxes
  for (BoundingBox box in renderedImage.boxes) {
    renderBox(outputImage, box.getRect(outputImage.width, outputImage.height),
        colors[box.objectClass]);
  }

  // Save image
  outputFileImage.writeAsBytesSync(encodeJpg(outputImage));
}

void renderBox(Image image, Rectangular rect, int color) {
  for (int i = 0; i < rectLineCount; i++) {
    drawRect(image, rect.x - i, rect.y - i, rect.x + rect.width + i,
        rect.y + rect.height + i, color);
  }
}
