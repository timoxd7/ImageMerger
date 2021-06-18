import 'dart:math';

import 'BackgroundDatabase.dart';
import 'ObjectDatabase.dart';
import 'RenderedImage.dart';

class Database {
  final ObjectDatabase objects;
  final BackgroundDatabase backgrounds = BackgroundDatabase();
  final List<String> classNameTable = <String>[];

  Database(Random random) : objects = ObjectDatabase(random);
}
