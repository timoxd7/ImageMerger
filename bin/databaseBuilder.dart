import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as path;

import 'Database/BackgroundElement.dart';
import 'Database/Database.dart';
import 'Database/ObjectElement.dart';

Database buildupDatabase(ArgResults results, Random random) {
  // Generate Database
  Database database = Database(random);

  // Read Classes
  print('Getting Objects...');
  String classesInput = results['classes'];

  if (classesInput == null || classesInput == '') {
    print('Wrong classes Path!');
    return null;
  }

  Directory classesDir = Directory(classesInput);

  if (!(classesDir.existsSync())) {
    print('Classes Directory not existing!');
    return null;
  }

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
          print("Strange input picture, can't decode!");
          return null;
        }

        ObjectElement objectElement = ObjectElement(currentImage, classCounter);

        database.objects.usableObjects.add(objectElement);
      }

      classCounter++;
    }
  }

  // Read Backgrounds
  print('Getting Backgrounds...');
  String backgroundsInput = results['background'];

  if (backgroundsInput == null || backgroundsInput == '') {
    print('Wrong background Path!');
    return null;
  }

  Directory backgroundsDir = Directory(backgroundsInput);

  if (!(backgroundsDir.existsSync())) {
    print('Background Directory not existing!');
    return null;
  }

  // Generate Backgrounds Database
  List<File> backgroundFiles = getImageFiles(backgroundsDir);

  for (File backgroundFile in backgroundFiles) {
    Image currentImage = decodeImage(backgroundFile.readAsBytesSync());

    if (currentImage == null) {
      print("Strange input background, can't decode!");
      return null;
    }

    BackgroundElement backgroundElement = BackgroundElement(currentImage);
    database.backgrounds.usableBackgrounds.add(backgroundElement);
  }

  // Database set up!
  return database;
}

List<File> getImageFiles(Directory dir) {
  List<File> returnList = <File>[];

  // Iterate throu all Files in this Directory and save all picture files
  for (FileSystemEntity entry in dir.listSync()) {
    if (entry is File) {
      String fileExtenstion = path.extension(entry.path);
      if (fileExtenstion == '.jpg' || fileExtenstion == '.png') {
        returnList.add(entry);
      }
    }
  }

  return returnList;
}
