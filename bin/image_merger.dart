import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:args/args.dart';

import 'IsolateConfig.dart';
import 'isolateFunc.dart';

const int stdImageCount = 2000;

const int stdMin = 2;
const int stdMax = 5;

const int stdMinSize = 5;
const int stdMaxSize = 90;

const int stdIsolateCount = 1;
const int stdConIsolateCount = 8;
const int stdMaxConcurrentBack = 256;

void main(List<String> arguments) async {
  ArgParser parser = ArgParser();

  // The Images for the Background
  parser.addOption('background', abbr: 'b');

  // The Folder to the Images in their class-subfolder
  parser.addOption('classes', abbr: 'c');

  // The Output-Folder for the Image-Box files
  parser.addOption('output', abbr: 'o');

  /// How many images should be created.
  /// Should be at least the amount of object pictures.
  parser.addOption('imagecount', abbr: 'i');

  // Min and Max of how many Objects should be put on one image
  parser.addOption('min');
  parser.addOption('max');

  // The min and max Size an object image gets resized (%)
  parser.addOption('minsize');
  parser.addOption('maxsize');

  // Optional Flag to export labeled images
  parser.addFlag('lable', abbr: 'l');

  // Optional to set how many isolates should be spawned
  parser.addOption('isolates');

  ArgResults results = parser.parse(arguments);

  // Parse Arguments
  int isolateCount = setByArg(results, 'isolates', stdIsolateCount);
  int imageCount = setByArg(results, 'imagecount', stdImageCount);
  int minObjectsCount = setByArg(results, 'min', stdMin);
  int maxObjectsCount = setByArg(results, 'max', stdMax);
  int minSize = setByArg(results, 'minsize', stdMinSize);
  int maxSize = setByArg(results, 'maxsize', stdMaxSize);
  bool lable = results['lable'];

  // Folder paths
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

  // Setup Output Folder
  String outputPath = results['output'];

  if (outputPath == null || outputPath == '') {
    print('Wrong output Path!');
    return;
  }

  Directory outputDir = Directory(outputPath);

  if (!(outputDir.existsSync())) {
    await outputDir.create(recursive: true);
  }

  // Spawn isolates
  List<ReceivePort> isolateList = <ReceivePort>[];
  bool success = true;

  for (int i = 0; i < isolateCount; i++) {
    int countOffset = (imageCount ~/ isolateCount) * i;
    ReceivePort receivePort = ReceivePort();

    IsolateConfig isolateConfig = IsolateConfig(
        i,
        countOffset,
        isolateCount,
        receivePort.sendPort,
        classesDir,
        backgroundsDir,
        minSize,
        maxSize,
        minObjectsCount,
        maxObjectsCount,
        imageCount ~/ isolateCount,
        lable,
        outputDir);

    await Isolate.spawn(isolateFunc, isolateConfig);

    isolateList.add(receivePort);
  }

  for (ReceivePort receivePort in isolateList) {
    success &= await receivePort.first;
  }

  print('All Done!');
}

int setByArg(ArgResults results, String name, int std) {
  if (results[name] == null || results[name] == '') {
    return std;
  } else {
    return int.parse(results[name] as String);
  }
}
