import 'dart:io';
import 'dart:math';

import 'package:image/image.dart';
import 'package:path/path.dart' as path;

import 'Database/BackgroundElement.dart';
import 'Database/Database.dart';
import 'Database/ObjectElement.dart';
import 'getImageFiles.dart';

Database buildupDatabase(Directory classesDir, Directory backgroundsDir,
    Random random, int isolateCount, int id) {
  // Generate Database
  Database database = Database(random);

  // Read Classes
  print('[' + id.toString() + '] Getting Objects...');

  // Generate Classes Database
  int classCounter = 0;

  for (FileSystemEntity entry in classesDir.listSync()) {
    if (entry is Directory) {
      List<File> imageFiles = getImageFiles(entry);
      String className = path.basename(entry.path);
      database.classNameTable.add(className);

      for (File imageFile in imageFiles) {
        // Generate Image Object
        Image currentImage = decodeImage(imageFile.readAsBytesSync());

        if (currentImage == null) {
          print('[' + id.toString() + "] Strange input picture, can't decode!");
          return null;
        }

        ObjectElement objectElement = ObjectElement(currentImage, classCounter);

        database.objects.usableObjects.add(objectElement);
      }

      classCounter++;
    }
  }

  // Read Backgrounds
  print('[' + id.toString() + '] Getting Backgrounds...');

  // Generate Backgrounds Database
  List<File> backgroundFiles = getImageFiles(backgroundsDir);

  // Only add needed Files
  int backgroundAmount = (backgroundFiles.length ~/ isolateCount);
  int backgroundOffset = backgroundAmount * id;
  backgroundFiles.removeRange(0, backgroundOffset);
  backgroundFiles.removeRange(backgroundAmount, backgroundFiles.length);

  for (File backgroundFile in backgroundFiles) {
    Image currentImage = decodeImage(backgroundFile.readAsBytesSync());

    if (currentImage == null) {
      print('[' + id.toString() + "] Strange input background, can't decode!");
      return null;
    }

    BackgroundElement backgroundElement = BackgroundElement(currentImage);
    database.backgrounds.usableBackgrounds.add(backgroundElement);
  }

  // Database set up!
  return database;
}
