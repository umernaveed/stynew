import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/account/controllers/refferal_users_controller.dart';

class RefferalUsersBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      RefferalUsersController(
        remoteRepository: find<RemoteRepository>(),
      ),
    );
  }
}
