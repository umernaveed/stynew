import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/core/routes/app_routes.dart';
import 'package:straight_to_yard/app/core/theme/light_theme.dart';
import 'package:straight_to_yard/app/services/push_notifications_service.dart';

// Future<void> getFcmToken() async {
//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//   String? token = await firebaseMessaging.getToken();
//   print('FCM Token: $token');
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Injector.setUp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // await getFcmToken();
  runApp(const StraightToYard());
}

class StraightToYard extends StatelessWidget {
  const StraightToYard({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          onInit: () {
            final badger = find<FlutterAppNotificationBadger>();
            badger.clearBadge();
          },
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },

          /// theme
          themeMode: ThemeMode.light,
          theme: LightTheme().themeData,

          ///
          initialRoute: AppRoutes.initialRoute,
          getPages: AppRoutes.routes,
          title: 'straight_to_yard',
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
