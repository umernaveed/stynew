import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/local_repository.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/onboarding/controllers/on_boarding_controller.dart';

class OnBoardingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      OnBoardingController(
        localRepository: find<LocalRepository>(),
        remoteRepository: find<RemoteRepository>(),
      ),
      permanent: true,
    );
  }
}
