import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/account/controllers/get_delivery_packages_controller.dart';

class AllDeliveryPackagesBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      AllDeliveryPackagesController(remoteRepository: find<RemoteRepository>()),
    );
  }
}
