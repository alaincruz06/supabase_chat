import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class FunctionUtils {
  //Encode / Decode image - base64
  static Future<String> base64encodedImageFromFile(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    // Convert the image bytes to base64
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  static Future<String> base64encodedImageFromPath(String imagePath) async {
    File file = File(imagePath);
    List<int> imageBytes = await file.readAsBytes();
    // Convert the image bytes to base64
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  static Future<Uint8List> base64decodeImageFromBase64String(
      String base64Data) async {
    Uint8List imageBytes = base64Decode(base64Data);
    return imageBytes;
  }
}
