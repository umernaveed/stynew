import 'package:get/get.dart';
import 'package:straight_to_yard/data/models/invoice/invoice.dart';
import 'package:straight_to_yard/data/models/requests/offset_request/offset_request.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/mixin/pagination_service.dart';

class InvoicesController extends GetxController
    with PaginationService<Invoice> {
  final RemoteRepository _remoteRepository;

  InvoicesController({required RemoteRepository remoteRepository})
      : _remoteRepository = remoteRepository;

  @override
  void onInit() {
    initlizieController();
    super.onInit();
  }

  @override
  void onClose() {
    disposeController();
    super.onClose();
  }

  @override
  Future<List<Invoice>> listener(int pageKey, {String keyToSearch = ''}) async {
    final res = await _remoteRepository.getAllInvoices(OffsetRequest(
      offset: pageKey.toString(),
      keyword: keyToSearch,
    ));
    return res.data.invoices;
  }
}
