import 'dart:io';

import 'package:path/path.dart' as path;

import 'getImageFiles.dart';

void generateConfig(
    Directory outputDir, Directory classesDir, int imageCount, int testCount) {
  // Check Classes and Class Names from classesDir
  List<String> classNames = <String>[];
  for (FileSystemEntity entry in classesDir.listSync()) {
    if (entry is Directory) {
      List<File> imageFiles = getImageFiles(entry);

      if (imageFiles.isNotEmpty) {
        String className = path.basename(entry.path);
        classNames.add(className);
      }
    }
  }

  // Generate List of Image and txt Names
  StringBuffer trainImageList = _getImageNames('obj', imageCount);
  StringBuffer testImageList = _getImageNames('test', testCount);

  File trainImageListFile = File(path.join(outputDir.path, 'train.txt'));
  trainImageListFile.writeAsStringSync(trainImageList.toString());

  File testImageListFile = File(path.join(outputDir.path, 'test.txt'));
  testImageListFile.writeAsStringSync(testImageList.toString());

  // Generate obj.name
  StringBuffer classNameBuffer = StringBuffer();
  classNameBuffer.writeAll(classNames, '\n');

  File objNamesFile = File(path.join(outputDir.path, 'obj.names'));
  objNamesFile.writeAsStringSync(classNameBuffer.toString());

  // Generate obj.data
  StringBuffer objDataBuffer = StringBuffer();
  objDataBuffer.writeAll([
    'classes = ',
    classNames.length.toString(),
    '\ntrain = data/train.txt\nvalid = data/test.txt\nnames = data/obj.names\nbackup = data/backup',
  ]);

  File objDataFile = File(path.join(outputDir.path, 'obj.data'));
  objDataFile.writeAsStringSync(objDataBuffer.toString());

  // Create empty Backup Dir
  Directory backupDir = Directory(path.join(outputDir.path, 'backup'));
  backupDir.createSync();
}

StringBuffer _getImageNames(String baseFolder, int count) {
  StringBuffer buffer = StringBuffer();

  for (int i = 0; i < count; i++) {
    buffer.write('data/');
    buffer.write(baseFolder);
    buffer.write('/');
    buffer.write(i.toString());
    buffer.write('\n');
  }

  return buffer;
}
