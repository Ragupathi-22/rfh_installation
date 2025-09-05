import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../app_utils/index_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getRoute();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getRoute() {
    Future.delayed(const Duration(seconds: 4), () {
       Navigator.pushNamedAndRemoveUntil(
          context,
          'login',
          (route) => false,
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(RImages.lightAppLogo),
            const SizedBox(height: RSizes.defaultSpace),
            SpinKitFadingCube(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: dark
                        ? const Color.fromARGB(255, 192, 201, 195)
                        : RColors.primary,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
