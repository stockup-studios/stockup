import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class Scanner {
  /// finds image file path from local storage
  static Future<String> getImageFilePath() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    // TODO: Error handling if file picker action was cancelled
    return result.files.single.path;
  }

  /// finds file paths of selected images from local storage
  static Future<List<String>> getImageFilePaths() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    // TODO: Error handling if file picker action was cancelled
    return result.paths;
  }

  /// finds barcodes found in image using GoogleMLKit Barcode API
  static Future<List<String>> getBarcodesFromImageFile(InputImage image) async {
    final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
    final List<Barcode> barcodes = await barcodeScanner.processImage(image);

    // extract barcodes of products
    List<String> productBarcodes;
    for (Barcode barcode in barcodes) {
      if (barcode.type == BarcodeType.product)
        productBarcodes.add(barcode.value.displayValue);
    }

    barcodeScanner.close();
    return productBarcodes;
  }

  /// finds text found in image using GoogleMLKit OCR
  static Future<List<String>> getTextFromImageFile(String inputFilePath) async {
    File inputFile = File(inputFilePath);
    InputImage inputImage = InputImage.fromFile(inputFile);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);

    List<String> text = [];
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        text.add(line.text);
      }
    }
    textDetector.close();
    return text;
  }
}
