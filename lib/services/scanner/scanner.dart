import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class Scanner {
  /// find image file path from local storage
  Future<String> getImageFilePath() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    return result.files.single.path;
  }

  /// find file paths of selected images from local storage
  Future<List<String>> getImageFilePaths() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    return result.paths;
  }

  /// find barcodes in image using GoogleMLKit Barcode API
  Future<List<String>> getBarcodesFromImageFile(InputImage image) async {
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

  /// find text in image using GoogleMLKit OCR
  Future<List<String>> getTextFromImageFile(String inputFilePath) async {
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
