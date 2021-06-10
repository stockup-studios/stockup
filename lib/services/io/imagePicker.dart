import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ImagePicker {
  Future<InputImage> getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    // TODO: Error handling if file picker action was cancelled
    File file = File(result.files.single.path);
    return InputImage.fromFile(file);
  }
}
