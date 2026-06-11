import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/local/favourite_post_services.dart';
import 'package:instagram/data/local/local_storage_service.dart';
import 'package:instagram/firebase_options.dart';
import 'package:instagram/routes/app_pages.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final LocalStorageService localStorageService = LocalStorageService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://iulownxcodnqzlefdavl.supabase.co',
    anonKey: 'sb_publishable_MW1p1cf5PACw9HsXo98d3A_V__qXdt3',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
    storageOptions: const StorageClientOptions(retryAttempts: 10),
  );
  EasyLoading.instance
    ..userInteractions = false
    ..dismissOnTap = false;

  await FavoritePostService.init();

  final localStorage = LocalStorageService();
  await localStorage.init();

  Get.put(localStorage);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 873),

      minTextAdapt: true,

      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'MyApp',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
