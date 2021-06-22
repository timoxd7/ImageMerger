import 'dart:math';

import 'Database/Database.dart';
import 'Database/RenderSettings.dart';
import 'IsolateConfig.dart';
import 'databaseBuilder.dart';
import 'renderer.dart';

void isolateFunc(IsolateConfig config) {
  // Get Random
  int seed = DateTime.now().millisecondsSinceEpoch;
  Random random = Random(seed);

  // Generate Database
  print('[' + config.id.toString() + ']Building Database...');
  Database database = buildupDatabase(config.classesDirectory,
      config.backgroundsDirectory, random, config.isolateCount, config.id);
  if (database == null) {
    print('[' + config.id.toString() + ']Error while generating Database!');
    config.sendPort.send(false);
    return;
  }

  RenderSettings renderSettings =
      RenderSettings(config.minSize / 100, config.maxSize / 100);

  // Render Images
  print('[' + config.id.toString() + ']Starting render...');
  render(
      config.id,
      database,
      renderSettings,
      config.minObjectsCount,
      config.maxObjectsCount,
      config.imageCount,
      random,
      config.label,
      config.outputDir,
      config.countOffset);

  print('[' + config.id.toString() + ']Done!');

  config.sendPort.send(true);
}
