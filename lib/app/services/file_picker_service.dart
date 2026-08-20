import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<File?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        return file;
      } else {
        throw FileNotFoundException();
      }
    } catch (e) {
      throw FileNotFoundException();
    }
  }
}

class FileNotFoundException implements Exception {
  FileNotFoundException();

  @override
  String toString() {
    return 'File Not Found ';
  }
}
