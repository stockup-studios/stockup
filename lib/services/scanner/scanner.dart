import 'package:google_ml_kit/google_ml_kit.dart';

class Scanner {
  /// finds barcodes found in image using GoogleMLKit Barcode API
  static Future<List<String>> getBarcodesFromImage(InputImage image) async {
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
  static Future<List<String>> getTextFromImage(InputImage input) async {
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(input);

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
