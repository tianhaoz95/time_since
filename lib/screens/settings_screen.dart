import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_since/screens/upgrade_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/signIn');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logged in as: ${FirebaseAuth.instance.currentUser?.email ?? 'N/A'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _signOut,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign Out'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UpgradeScreen()));
              },
              child: const Text('Upgrade'),
            ),
          ],
        ),
      ),
    );
  }
}
