import 'package:image/image.dart' as im;

class ObjectElement {
  final im.Image image;
  final int objectClass;
  int timesUsed = 0;

  ObjectElement(this.image, this.objectClass);

  ObjectElement copyResize(double factor) {
    int newWidth = (image.width * factor).toInt();

    im.Image newImage = im.copyResize(image, width: newWidth);

    ObjectElement newObjectElement = ObjectElement(newImage, objectClass);

    return newObjectElement;
  }
}
