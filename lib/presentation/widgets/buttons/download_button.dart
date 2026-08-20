import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/presentation/controller/download_file_controller.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/download_dialog.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/file_upload_dialog.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.showDownloadButton,
    required this.id,
    this.onDone,
    this.fileURL,
  });
  final bool showDownloadButton;
  final int id;
  final VoidCallback? onDone;
  final String? fileURL;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showDownloadButton && (fileURL?.isNotEmpty ?? false)) {
          final controller = find<FileDownloadController>();
          controller.downloadFile(fileURL!);
          Get.dialog(const DownloadDialog());
        } else {
          Get.dialog(
            FileUploadDialog(
              id: id,
              onDone: onDone,
            ),
          );
        }
      },
      child: Container(
        width: context.width,
        height: 5.h,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            showDownloadButton ? 'Download Invoice' : 'Upload Invoice',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
