import 'package:image/image.dart' as im;

class ObjectElement {
  final im.Image image;
  final int objectClass;
  int timesUsed = 0;

  ObjectElement(this.image, this.objectClass);

  factory ObjectElement.copy(ObjectElement other) {
    im.Image imageCopy =
        im.copyCrop(other.image, 0, 0, other.image.width, other.image.height);

    ObjectElement newObjectElement =
        ObjectElement(imageCopy, other.objectClass);
    newObjectElement.timesUsed = other.timesUsed;

    return newObjectElement;
  }

  factory ObjectElement.differentImage(ObjectElement other, im.Image image) {
    ObjectElement newObjectElement = ObjectElement(image, other.objectClass);
    newObjectElement.timesUsed = other.timesUsed;

    return newObjectElement;
  }
}
