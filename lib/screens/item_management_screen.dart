import 'package:flutter/material.dart';

class ItemManagementScreen extends StatelessWidget {
  const ItemManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Management')),
      body: const Center(
        child: Text('Item Management Screen Content'),
      ),
    );
  }
}
