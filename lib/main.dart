import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await InitialBinding().initialBinding();
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}
