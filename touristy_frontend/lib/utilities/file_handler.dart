import 'dart:io';
import 'dart:convert';

class FileHandler {
  //convert image to base64
  static String convertFileToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}
