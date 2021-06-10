import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:stockup/services/io/imagePicker.dart';

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
}
