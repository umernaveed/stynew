import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/news/news_controller.dart';

class NewsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      NewsController(
        remoteRepository: find<RemoteRepository>(),
      ),
    );
  }
}
