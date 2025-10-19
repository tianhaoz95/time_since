import 'package:flutter/material.dart';

class ItemStatusScreen extends StatelessWidget {
  const ItemStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Status')),
      body: const Center(
        child: Text('Item Status Screen Content'),
      ),
    );
  }
}
