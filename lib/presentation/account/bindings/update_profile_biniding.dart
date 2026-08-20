import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/services/image_service.dart';
import 'package:straight_to_yard/domain/repositories/local_repository.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/account/controllers/update_profile_controller.dart';

class UpdateProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      UpdateProfileController(
        remoteRepository: find<RemoteRepository>(),
        localRepository: find<LocalRepository>(),
        imagePicker: find<IImagePicker>(),
      ),
    );
  }
}
