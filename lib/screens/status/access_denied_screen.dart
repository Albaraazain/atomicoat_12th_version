import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:experiment_planner/providers/auth_provider.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Access Denied',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your account has been deactivated or denied access.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false).signOut();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}