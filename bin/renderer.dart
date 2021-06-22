import 'dart:io';
import 'dart:math';

import 'package:image/image.dart';

import 'Database/Database.dart';
import 'Database/ObjectElement.dart';
import 'Database/RenderSettings.dart';
import 'Database/RenderedImage.dart';
import 'ImageTools/transformer.dart';
import 'exporter.dart';

/// Renders all Images by the given Configuration, adds Object Image
/// transformations and exports all
void render(
    int id,
    Database database,
    RenderSettings renderSettings,
    int minObjectCount,
    int maxObjectCount,
    int imageCount,
    Random random,
    bool exportLabeled,
    Directory outputDir,
    int countOffset) {
  int nextToReportPercentage = 0;

  for (int i = 0; i < imageCount; i++) {
    // Show Progress
    if ((i / imageCount) * 100 >= nextToReportPercentage) {
      int actualPercentage = ((i / imageCount) * 100).toInt();
      int calculatedPercentage = nextToReportPercentage + 1;

      printPercent(id, actualPercentage);
      nextToReportPercentage = max(actualPercentage, calculatedPercentage);
    }

    // Render Image
    // Get Objects
    int objectCount = random.nextInt(maxObjectCount - minObjectCount);
    objectCount += minObjectCount;

    List<ObjectElement> currentObjects = <ObjectElement>[];
    for (int j = 0; j < objectCount; j++) {
      ObjectElement currentObject = database.objects.getNextObject();

      // Apply Transformations
      Image transformedImage =
          applyTransforms(random, currentObject.image, renderSettings);

      currentObjects
          .add(ObjectElement.differentImage(currentObject, transformedImage));
    }

    // Render Image
    RenderedImage newRenderedImage =
        RenderedImage(random, database.backgrounds.getNext(), currentObjects);

    // Write to Storage
    exporter(outputDir, newRenderedImage, exportLabeled, countOffset);
  }
}

void printPercent(int id, int percent) {
  print('[' + id.toString() + '] ' + percent.toString() + '%');
}
