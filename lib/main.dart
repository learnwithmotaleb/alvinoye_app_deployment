import 'package:delivery_app/core/service/datasource/remote/app_permission_service.dart';
import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/di/getx_injection.dart';
import 'core/di/injection.dart';
import 'core/router/routes.dart';
import 'core/service/datasource/local/local_service.dart';
import 'core/theme/light_theme.dart';
import 'helper/device_utils/device_utils.dart';
import 'share/controller/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  DeviceUtils.lockDevicePortrait();

  await LocalService.init(); // ✅ MUST be first
  initGetx();
  await initDependencies();
  await SocketApi.init();
  await AppPermissionService.requestAllPermissions();

  Map<String, Map<String, String>>? languages =
      await LanguageController.getLanguages();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(languages: languages),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.languages});
  final Map<String, Map<String, String>>? languages;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => GetMaterialApp.router(
        debugShowCheckedModeBanner: false,

        //Route Section
        routeInformationParser: AppRouter.route.routeInformationParser,
        routerDelegate: AppRouter.route.routerDelegate,
        routeInformationProvider: AppRouter.route.routeInformationProvider,

        //Theme Section
        themeMode: ThemeMode.light,
        theme: lightTheme,
        /* darkTheme: darkTheme,*/

        //Languages Section
        locale: Locale("en", "US"),
        translations: Messages(languages: languages),
        fallbackLocale: const Locale("en", "US"),
      ),
    );
  }
}
