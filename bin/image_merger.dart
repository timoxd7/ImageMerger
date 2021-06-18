import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:args/args.dart';

import 'Database/Database.dart';
import 'Database/RenderSettings.dart';
import 'databaseBuilder.dart';
import 'exporter.dart';
import 'renderer.dart';

const int stdImageCount = 2000;

const int stdMin = 2;
const int stdMax = 5;

const int stdMinSize = 5;
const int stdMaxSize = 90;

const int stdIsolateCount = 1;
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

  // Optional seed for random generator
  parser.addOption('seed');

  // Optional Flag to export labeled images
  parser.addFlag('lable', abbr: 'l');

  ArgResults results = parser.parse(arguments);

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

  // Get Random
  int seed;
  if (results['seed'] != null && results['seed'] != '') {
    seed = results['seed'];
  } else {
    seed = DateTime.now().millisecondsSinceEpoch;
  }

  Random random = Random(seed);

  // Generate Database
  print("Building Database...");
  Database database = buildupDatabase(results, random);
  if (database == null) {
    print('Error while generating Database!');
    return;
  }

  int imageCount = setByArg(results, 'imagecount', stdImageCount);
  int minObjectsCount = setByArg(results, 'min', stdMin);
  int maxObjectsCount = setByArg(results, 'max', stdMax);
  int minSize = setByArg(results, 'minsize', stdMinSize);
  int maxSize = setByArg(results, 'maxsize', stdMaxSize);

  RenderSettings renderSettings = RenderSettings(minSize / 100, maxSize / 100);

  print("Starting render...");
  render(database, renderSettings, minObjectsCount, maxObjectsCount, imageCount,
      random, results['lable'], outputDir);

  print('Done!');
}

int setByArg(ArgResults results, String name, int std) {
  if (results[name] == null || results[name] == '') {
    return std;
  } else {
    return int.parse(results[name] as String);
  }
}
