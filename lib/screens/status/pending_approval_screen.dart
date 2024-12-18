import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:experiment_planner/providers/auth_provider.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Your account is pending approval',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Please wait for an administrator to approve your account.',
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