import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/extensions/controller_ext.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/data/models/create_delivery_request/create_delivery_request.dart';
import 'package:straight_to_yard/data/models/manage_pick_up_request_meta/area.dart';
import 'package:straight_to_yard/data/models/manage_pick_up_request_meta/day.dart';
import 'package:straight_to_yard/data/models/user/user.dart';
import 'package:straight_to_yard/domain/repositories/local_repository.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/delivery/controllers/delivery_controller.dart';

class ManagePickUpRequestController extends GetxController {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final DeliveryController _deliveryController;

  ManagePickUpRequestController({
    required RemoteRepository remoteRepository,
    required LocalRepository localRepository,
  })  : _remoteRepository = remoteRepository,
        _localRepository = localRepository,
        _deliveryController = find<DeliveryController>();

  final areas = <Area>[];
  final days = <Day>[];
  String coast = '0';
  User user = User.empty();
  final formKey = GlobalKey<FormBuilderState>();
  TextEditingController coastController = TextEditingController(text: '0');

  @override
  void onReady() {
    super.onReady();
    _fetchMeta();
  }

  @override
  void onClose() {
    coastController.dispose();
    super.onClose();
  }

  void onAreaChange(Area area) {
    coast = area.cost ?? '0';
    coastController.text = coast;
  }

  Future<void> onSchedule() async {
    bool isSuccess = false;
    String message = '';
    await asyncTask(() async {
      formKey.currentState?.save();
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) return;
      final formData = formKey.currentState?.value ?? {};
      final _ = CreateDeliveryRequest.fromMap(formData);
      final ids = _deliveryController.selectedItems
          .map((e) => e.trackingNo)
          .toList()
          .join(',');
      final request = _.copyWith(
        noOfPackages: _deliveryController.selectedItems.length.toString(),
        packageTotal: _deliveryController.totalAmount.value.toString(),
        packageIds: ids,
      );
      final result = await _remoteRepository.createDeliveryRequest(request);
      isSuccess = result.status;
      message = result.message;
    });
    if (isSuccess) {
      _deliveryController.onRefresh();
      final bottomNavNestedID = find<BottomNavController>().bottomNavNestedID;
      Get.back(id: bottomNavNestedID);
      FlushSnackbar.showSnackBar(message);
    }
  }

  Future<void> _fetchMeta() async {
    await asyncTask(() async {
      final result = await _remoteRepository.getManagePickUpRequestMeta();
      final a = result.data.areas ?? [];
      final d = result.data.days ?? [];
      areas.addAll(a);
      days.addAll(d);
    }).then((value) {
      update(['manage_pickup_request']);
    });
  }

  User getInstantUser() {
    final r = _localRepository.getInstantUser();
    return r;
  }
}
