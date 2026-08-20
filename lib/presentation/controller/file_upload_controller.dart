import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:straight_to_yard/app/services/file_picker_service.dart';
import 'package:straight_to_yard/app/services/image_service.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/data/models/requests/upload_invoice_request/upload_invoice_request.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';

class FileUploadController extends GetxController {
  final FilePickerService _filePickerService;
  final RemoteRepository _remoteRepository;
  final IImagePicker _iImagePicker;

  FileUploadController(
      {required FilePickerService filePickerService,
      required RemoteRepository remoteRepository,
      required IImagePicker iImagePicker})
      : _filePickerService = filePickerService,
        _remoteRepository = remoteRepository,
        _iImagePicker = iImagePicker;

  File? file;
  double uploadProgress = 0.0;
  VoidCallback? onDone;

  void clearFile() {
    file = null;
    uploadProgress = 0.0;
    update(['fileBuilder']);
  }

  Future<void> uploadFile(UploadInvoiceRequest request) async {
    try {
      if (file == null) return;
      final result = await _remoteRepository.uploadInvoice(
        request: request,
        file: file!,
        uploadProgress: (e) {
          uploadProgress = e;
          update(['fileBuilder']);
        },
      );
      if (result.status) {
        onDone?.call();
        clearFile();
        FlushSnackbar.showSnackBar('Invoice has been uploaded Successfully');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> pickFile({bool isImage = false}) async {
    try {
      if (isImage) {
        file = await _iImagePicker.pickImageFromGallery(allowCrope: false);
      } else {
        file = await _filePickerService.pickFile();
      }

      update(['fileBuilder']);
    } catch (_) {}
  }
}
