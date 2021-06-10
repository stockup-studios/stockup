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
    InputImage image = InputImage.fromFile(file);
    return image;
  }

  Future<List<InputImage>> getImages() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    // TODO: Error handling if file picker action was cancelled
    List<File> files = result.paths.map((path) => File(path)).toList();
    List<InputImage> images = [];
    for (File file in files) {
      InputImage image = InputImage.fromFile(file);
      images.add(image);
    }
    return images;
  }
}
