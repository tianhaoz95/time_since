import 'package:flutter/material.dart';
import 'package:time_since/models/tracking_item.dart';

class ItemStatusScreen extends StatefulWidget {
  const ItemStatusScreen({super.key});

  @override
  State<ItemStatusScreen> createState() => _ItemStatusScreenState();
}

class _ItemStatusScreenState extends State<ItemStatusScreen> {
  final List<TrackingItem> _trackingItems = [
    TrackingItem(id: '1', name: 'AC Filter'),
    TrackingItem(id: '2', name: 'Water Filter'),
    TrackingItem(id: '3', name: 'Car Oil Change'),
  ];

  void _logNow(TrackingItem item) {
    // TODO: Implement log now functionality
    print('Log now for: ${item.name}');
  }

  void _addCustomDate(TrackingItem item) {
    // TODO: Implement add custom date functionality
    print('Add custom date for: ${item.name}');
  }

  void _viewHistory(TrackingItem item) {
    // TODO: Implement view history functionality
    print('View history for: ${item.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Status'),
      ),
      body: ListView.builder(
        itemCount: _trackingItems.length,
        itemBuilder: (context, index) {
          final item = _trackingItems[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => _logNow(item),
                        child: const Text('Log Now'),
                      ),
                      ElevatedButton(
                        onPressed: () => _addCustomDate(item),
                        child: const Text('Custom Date'),
                      ),
                      ElevatedButton(
                        onPressed: () => _viewHistory(item),
                        child: const Text('View History'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
