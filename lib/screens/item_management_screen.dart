import 'package:flutter/material.dart';
import 'package:time_since/models/tracking_item.dart';

class ItemManagementScreen extends StatefulWidget {
  const ItemManagementScreen({super.key});

  @override
  State<ItemManagementScreen> createState() => _ItemManagementScreenState();
}

class _ItemManagementScreenState extends State<ItemManagementScreen> {
  final List<TrackingItem> _trackingItems = [
    TrackingItem(id: '1', name: 'AC Filter'),
    TrackingItem(id: '2', name: 'Water Filter'),
    TrackingItem(id: '3', name: 'Car Oil Change'),
  ];

  void _addItem() {
    TextEditingController itemNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: TextField(
            controller: itemNameController,
            decoration: const InputDecoration(hintText: 'Item Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (itemNameController.text.isNotEmpty) {
                  setState(() {
                    _trackingItems.add(
                      TrackingItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: itemNameController.text,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editItem(TrackingItem item) {
    // TODO: Implement edit item functionality
    print('Edit item: ${item.name}');
  }

  void _deleteItem(TrackingItem item) {
    // TODO: Implement delete item functionality
    print('Delete item: ${item.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Management'),
      ),
      body: ListView.builder(
        itemCount: _trackingItems.length,
        itemBuilder: (context, index) {
          final item = _trackingItems[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _editItem(item),
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => _deleteItem(item),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
