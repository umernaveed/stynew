import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/unpaid_invoices/controllers/unpaid_invoices.dart';

class UnpaidInvoicesBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      UnpaidInvoicesController(
        remoteRepository: find<RemoteRepository>(),
      ),
    );
  }
}
