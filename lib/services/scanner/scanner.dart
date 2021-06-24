import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:stockup/services/io/imagePicker.dart';
import 'package:stockup/services/parser/parser.dart';

class Scanner {
  Future<List<String>> getBarcodesFromImage() async {
    final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
    final InputImage inputImage = await ImagePicker().getImage();
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    // extract barcodes of products
    List<String> productBarcodes;
    for (Barcode barcode in barcodes) {
      if (barcode.type == BarcodeType.product)
        productBarcodes.add(barcode.value.displayValue);
    }

    barcodeScanner.close();
    return productBarcodes;
  }

  Future<List<String>> _getTextFromImage() async {
    final textDetector = GoogleMlKit.vision.textDetector();
    final InputImage inputImage = await ImagePicker().getImage();
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

  // Extract item name from the captured text using parser
  Future<List<String>> extractDataFromTxt() async {
    List<String> text = await _getTextFromImage();
    return Parser(text: text).getBestMatches();
  }
}
