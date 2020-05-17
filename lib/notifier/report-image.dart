import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ReportImageNotifier extends ChangeNotifier {
  File mediaFile;
  void pickFile() async {
    mediaFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  void openCamera() async {
    mediaFile = await ImagePicker.pickImage(source: ImageSource.camera);
    notifyListeners();
  }

  void generateUploadFileName() {}
}
