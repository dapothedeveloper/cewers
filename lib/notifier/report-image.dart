import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ReportImageNotifier extends ChangeNotifier {
  File mediaFile;
  double uploadProgress = 0;
  void pickFile() async {
    // ignore: deprecated_member_use
    mediaFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  void openCamera() async {
    // ignore: deprecated_member_use
    mediaFile = await ImagePicker.pickImage(source: ImageSource.camera);
    notifyListeners();
  }

  void generateUploadFileName() {}
}
