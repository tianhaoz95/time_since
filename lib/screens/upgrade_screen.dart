import 'package:flutter/material.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.red.withOpacity(0.5),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'This app is currently in beta. Subscriptions are not yet available.',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Unlock Premium Features!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement in-app purchase logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('In-app purchase not yet implemented.')),
                );
              },
              child: const Text('Subscribe Now'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No thanks, maybe later.'),
            ),
          ],
        ),
      ),
    );
  }
}
