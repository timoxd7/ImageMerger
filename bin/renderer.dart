import 'dart:io';
import 'dart:math';

import 'Database/Database.dart';
import 'Database/ObjectElement.dart';
import 'Database/RenderSettings.dart';
import 'Database/RenderedImage.dart';
import 'exporter.dart';

void render(
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

      printPercent(actualPercentage);
      nextToReportPercentage = max(actualPercentage, calculatedPercentage);
    }

    // Render Image
    // Get Objects
    int objectCount = random.nextInt(maxObjectCount - minObjectCount);
    objectCount += minObjectCount;

    List<ObjectElement> currentObjects = <ObjectElement>[];

    for (int j = 0; j < objectCount; j++) {
      currentObjects.add(database.objects.getNextObject());
    }

    // Render Image
    RenderedImage newRenderedImage = RenderedImage(
        random, database.backgrounds.getNext(), currentObjects, renderSettings);

    // Write to Storage
    exporter(outputDir, newRenderedImage, exportLabeled, countOffset);
  }
}

void printPercent(int percent) {
  print(percent.toString() + '%');
}
