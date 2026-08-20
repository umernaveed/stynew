import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/purchase/controllers/purchase_controller.dart';

class PurchaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PurchaseController(remoteRepository: find<RemoteRepository>()));
  }
}
