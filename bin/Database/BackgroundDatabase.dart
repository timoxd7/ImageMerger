import 'BackgroundElement.dart';

class BackgroundDatabase {
  final List<BackgroundElement> usableBackgrounds = <BackgroundElement>[];
  final List<BackgroundElement> _usableForNextBackgrounds =
      <BackgroundElement>[];

  BackgroundElement getNext() {
    if (usableBackgrounds.isEmpty) {
      usableBackgrounds.addAll(_usableForNextBackgrounds);
      _usableForNextBackgrounds.clear();
      usableBackgrounds.shuffle();
    }

    BackgroundElement returnObj = usableBackgrounds[0];
    usableBackgrounds.removeAt(0);
    _usableForNextBackgrounds.add(returnObj);
    returnObj.timesUsed++;

    return returnObj;
  }
}
