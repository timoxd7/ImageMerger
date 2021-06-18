import 'dart:math';

import 'ObjectElement.dart';

class ObjectDatabase {
  final Random random;
  final List<ObjectElement> usableObjects = <ObjectElement>[];

  final List<ObjectElement> _usableForNextObjects = <ObjectElement>[];

  ObjectDatabase(Random this.random);

  ObjectElement getNextObject() {
    if (usableObjects.isEmpty) {
      usableObjects.addAll(_usableForNextObjects);
      _usableForNextObjects.clear();
      usableObjects.shuffle();
    }

    int nextIndex = random.nextInt(usableObjects.length);

    ObjectElement returnObj = usableObjects[nextIndex];
    usableObjects.removeAt(nextIndex);
    _usableForNextObjects.add(returnObj);
    returnObj.timesUsed++;

    return returnObj;
  }
}
