import 'dart:io';

import 'package:path/path.dart' as path;

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
