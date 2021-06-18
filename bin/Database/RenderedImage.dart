import 'dart:math';

import 'package:image/image.dart';

import 'BackgroundElement.dart';
import 'BoundingBox.dart';
import 'ObjectElement.dart';
import 'Rectangular.dart';
import 'RenderSettings.dart';

const int maxPlaceTries = 100;
const double maxOverlapArea = 0.5;

class RenderedImage {
  final Image image;
  final List<BoundingBox> boxes;

  RenderedImage._internal(this.image, this.boxes);

  /// Resizes and places the Objects on the Background and generates the
  /// bounding boxes
  factory RenderedImage(Random random, BackgroundElement background,
      List<ObjectElement> objects, RenderSettings settings) {
    List<Rectangular> foundPositions = <Rectangular>[];
    List<BoundingBox> addedBoundingBoxes = <BoundingBox>[];
    // Copy image to
    Image destImage = copyCrop(background.image, 0, 0, background.image.width,
        background.image.height);

    for (ObjectElement object in objects) {
      // Resize the Object by a random value
      double newSize = settings.maxSize - settings.minSize;
      newSize *= random.nextDouble();
      newSize += settings.minSize;
      ObjectElement resizedObject = object.copyResize(newSize);

      // Find new Position
      Rectangular newPosition = _getNewImagePosition(
          random, background, resizedObject, foundPositions);

      if (newPosition == null) break;

      foundPositions.add(newPosition);

      // Merge into picture
      BoundingBox mergedObject =
          _mergeIntoImage(destImage, newPosition, resizedObject);

      // Add bounding box
      addedBoundingBoxes.add(mergedObject);
    }

    return RenderedImage._internal(destImage, addedBoundingBoxes);
  }

  static Rectangular _getNewImagePosition(
      Random random,
      BackgroundElement backgroundElement,
      ObjectElement objectElement,
      List<Rectangular> presetPositions) {
    int placeTries = 0;

    // Calculate possible X and Y
    int maxX = backgroundElement.image.width - objectElement.image.width;
    int maxY = backgroundElement.image.height - objectElement.image.height;

    Rectangular returnRect;

    while (true) {
      // New Position
      int xPos = random.nextInt(maxX);
      int yPos = random.nextInt(maxY);
      returnRect = Rectangular(
          xPos, yPos, objectElement.image.width, objectElement.image.height);

      // Check for collision
      bool tooBigIntersection = false;
      if (presetPositions == null) break;
      for (Rectangular otherRect in presetPositions) {
        double intersectArea = returnRect.getIntersectArea(otherRect);
        if (intersectArea >= maxOverlapArea) {
          tooBigIntersection = true;
          break;
        }
      }

      if (!tooBigIntersection) break;

      // Check for out of tries
      if (++placeTries > maxPlaceTries) {
        return null;
      }
    }

    return returnRect;
  }

  static BoundingBox _mergeIntoImage(
      Image image, Rectangular position, ObjectElement objectElement) {
    copyInto(image, objectElement.image, dstX: position.x, dstY: position.y);
    BoundingBox returnVal = BoundingBox.fromPlacedImage(
        objectElement.objectClass,
        position.x,
        position.y,
        image.width,
        image.height,
        objectElement.image.width,
        objectElement.image.height);

    return returnVal;
  }
}
