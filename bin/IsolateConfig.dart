import 'dart:io';
import 'dart:isolate';

class IsolateConfig {
  final int id;
  final int countOffset;

  final int isolateCount;
  final SendPort sendPort;

  final Directory classesDirectory;
  final Directory backgroundsDirectory;

  final int minSize;
  final int maxSize;

  final int minObjectsCount;
  final int maxObjectsCount;
  final int imageCount;
  final bool label;
  final Directory outputDir;

  IsolateConfig(
    this.id,
    this.countOffset,
    this.isolateCount,
    this.sendPort,
    this.classesDirectory,
    this.backgroundsDirectory,
    this.minSize,
    this.maxSize,
    this.minObjectsCount,
    this.maxObjectsCount,
    this.imageCount,
    this.label,
    this.outputDir,
  );
}
