import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/services/file_picker_service.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/account/controllers/add_alert_controller.dart';

class AddPreControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      AddPreAlertController(
          remoteRepository: find<RemoteRepository>(),
          filePickerService: find<FilePickerService>()),
    );
  }
}
