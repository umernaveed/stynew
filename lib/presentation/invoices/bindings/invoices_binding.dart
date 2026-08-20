import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/invoices/controller/invoices_controller.dart';

class InvoicesBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      InvoicesController(remoteRepository: find<RemoteRepository>()),
    );
  }
}
