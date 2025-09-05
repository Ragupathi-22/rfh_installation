import 'package:flutter/material.dart';
import 'package:rfhinstaller/app_utils/custom_widget/app_bar.dart';

class AspDashboard extends StatefulWidget {
  const AspDashboard({super.key});

  @override
  State<AspDashboard> createState() => _AspDashboardState();
}

class _AspDashboardState extends State<AspDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        automaticallyImplyLeading: false,
        action: true,
        title: 'ASP Dashboard',
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Text(
              'ASP Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Welcome to ASP Dashboard',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
