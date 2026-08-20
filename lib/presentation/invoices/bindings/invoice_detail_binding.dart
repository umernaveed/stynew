import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/invoices/controller/invoice_detail_controller.dart';

class InvoiceDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      InvoiceDetailController(remoteRepository: find<RemoteRepository>()),
    );
  }
}
