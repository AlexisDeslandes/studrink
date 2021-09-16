import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as Img;

class ImageUtils {
  ///
  /// Crop the image represent by [bytes] removing
  /// extra white space and transparency surrounded image.
  ///
  static Future<Uint8List> crop(Uint8List bytes) async {
    final image = Img.bakeOrientation(Img.decodeImage(bytes)!);
    final cropRectangle = _cropRectangle(image);
    final cropImage = _cropImage(cropRectangle, image);
    final newPng = Img.encodePng(cropImage);
    return Uint8List.fromList(newPng);
  }

  static Rectangle<int> _cropRectangle(Img.Image src) {
    final width = src.width, height = src.height, imgSize = width * 0.8;
    int top = (height / 2 - imgSize / 2).toInt(),
        bottom = (height / 2 + imgSize / 2).toInt(),
        left = (width / 2 - imgSize / 2).toInt(),
        right = (width / 2 + imgSize / 2).toInt();
    return Rectangle(left, top, right - left, bottom - top);
  }

  static Img.Image _cropImage(Rectangle<int> cropRectangle, Img.Image image) {
    final img = Img.Image(cropRectangle.width, cropRectangle.height),
        top = cropRectangle.top,
        left = cropRectangle.left;
    for (var x = 0; x < cropRectangle.width; x++) {
      for (var y = 0; y < cropRectangle.height; y++) {
        img.setPixel(x, y, image.getPixel(x + left, y + top));
      }
    }
    return img;
  }
}
