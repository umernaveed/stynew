import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/local_repository.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/delivery/controllers/manage_pickup_request_controller.dart';

class ManagePickUpRequestBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      ManagePickUpRequestController(
        remoteRepository: find<RemoteRepository>(),
        localRepository: find<LocalRepository>(),
      ),
    );
  }
}
