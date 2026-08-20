import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:straight_to_yard/app/services/app_permission_service.dart';
import 'package:straight_to_yard/app/services/device_service.dart';
import 'package:straight_to_yard/app/services/file_picker_service.dart';
import 'package:straight_to_yard/app/services/image_service.dart';
import 'package:straight_to_yard/app/services/push_notifications_service.dart';
import 'package:straight_to_yard/app/services/storage_service.dart';
import 'package:straight_to_yard/data/datasource/local_data_source.dart';
import 'package:straight_to_yard/data/datasource/remote_data_source.dart';
import 'package:straight_to_yard/data/network/api_client.dart';
import 'package:straight_to_yard/data/network/end_points.dart';
import 'package:straight_to_yard/data/repositories/local_respository_imp.dart';
import 'package:straight_to_yard/data/repositories/remote_repossitory_imp.dart';
import 'package:straight_to_yard/domain/datasource/local_data_source.dart';
import 'package:straight_to_yard/domain/datasource/remote_data_source.dart';
import 'package:straight_to_yard/domain/repositories/local_repository.dart';
import 'package:straight_to_yard/domain/repositories/remote_repository.dart';
import 'package:straight_to_yard/presentation/controller/download_file_controller.dart';
import 'package:straight_to_yard/presentation/controller/file_upload_controller.dart';

T find<T>() {
  return Get.find<T>();
}

T put<T>(T type, {bool permanent = false}) {
  return Get.put<T>(type, permanent: permanent);
}

void lazyPut<T>(T type) {
  return Get.lazyPut<T>(() => type);
}

abstract class Injector {
  static void setUp() {
    /// Core
    Get.put<LocalClient>(
      LocalClientImp(hive: Hive),
    );
    Get.put<DeviceInfoProvider>(DeviceInfoProvider());

    Get.put<IApiClient>(
      ApiClient(
        connect: GetConnect(),
        baseURL: EndPoints.baseURL,
        logger: Logger(),
      ),
    );

    //// data source
    Get.put<RemoteDataSource>(
      RemoteDataSourceImp(
        apiClient: find<IApiClient>(),
      ),
    );
    Get.put<LocalDataSource>(
      LocalDataSourceImp(
        localClient: find<LocalClient>(),
      ),
    );

    /// repositories
    Get.put<RemoteRepository>(
      RemoteRepositoryImp(remoteDataSource: find<RemoteDataSource>()),
    );
    Get.put<LocalRepository>(
      LocalRepositoryImp(localDataSource: find<LocalDataSource>()),
    );

    /// services
    Get.put(FilePickerService());
    Get.put(PermissionService());
    Get.put<IImagePicker>(ImagePickerImp());
    Get.put<StorageService>(StorageServiceImpl());
    Get.put(
      FileUploadController(
        filePickerService: find<FilePickerService>(),
        remoteRepository: find<RemoteRepository>(),
        iImagePicker: find<IImagePicker>(),
      ),
    );
    Get.put(
      FileDownloadController(
        remoteRepository: find<RemoteRepository>(),
        service: find<StorageService>(),
      ),
    );

    put<FlutterAppNotificationBadger>(FlutterAppNotificationBadger());
  }
}
