import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/delivery/controllers/delivery_controller.dart';

class DeliveryBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      DeliveryController(
        remoteRepository: find<RemoteRepository>(),
      ),
    );
  }
}
