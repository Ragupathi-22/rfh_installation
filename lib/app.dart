import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'app_pages/index_pages.dart';
import 'app_utils/index_utils.dart';
import 'main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFH Installation',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      initialRoute: 'splash',
      builder: EasyLoading.init(),
      // onGenerateRoute: AppRoute.allRoutes,
      navigatorKey: navigatorKey,
      theme: RAppTheme.lightTheme,
      darkTheme: RAppTheme.darkTheme,
      routes: {
        'splash': (context) => SplashScreen(),
        'login': (context) => LoginPage(),
        'adminDashboard': (context) => const AdminDashboard(),
        'aspDashboard': (context) => const AspDashboard(), // You'll need to create this
        'mechanicDashboard': (context) => const MechanicDashboard(), // You'll need to create this
      },
    );
  }
}

class InitialBinding {
  initialBinding() async {
    // Ensures Flutter binding is initialized
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize Hive
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
        Hive.init(appDocumentDir.path);
    // Open the box
    await Hive.openBox('box_Installer');
  }
}
