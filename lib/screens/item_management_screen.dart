import 'package:flutter/material.dart';
import 'package:time_since/models/tracking_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_since/screens/upgrade_screen.dart';

class ItemManagementScreen extends StatefulWidget {
  const ItemManagementScreen({super.key});

  @override
  State<ItemManagementScreen> createState() => _ItemManagementScreenState();
}

class _ItemManagementScreenState extends State<ItemManagementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  void _addItem() async {
    if (currentUser == null) return;

    // Check current item count
    final itemsSnapshot = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('items')
        .get();

    if (itemsSnapshot.docs.length >= 5) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upgrade Required'),
              content: const Text('Free tier users are limited to 5 items. Please upgrade to add more.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Upgrade'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpgradeScreen()));
                  },
                ),
              ],
            );
          },
        );
      }
      return;
    }

    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemNotesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemNameController,
                decoration: const InputDecoration(hintText: 'Item Name'),
              ),
              TextField(
                controller: itemNotesController,
                decoration: const InputDecoration(hintText: 'Notes (Optional)'),
              ),
            ],
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
              onPressed: () async {
                if (itemNameController.text.isNotEmpty) {
                  try {
                    await _firestore
                        .collection('users')
                        .doc(currentUser!.uid)
                        .collection('items')
                        .add(
                          TrackingItem(
                            id: '',
                            name: itemNameController.text,
                            lastDate: DateTime.now(),
                            notes: itemNotesController.text.isEmpty ? null : itemNotesController.text,
                          ).toFirestore(),
                        );
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding item: $e')),
                      );
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editItem(TrackingItem item) {
    if (currentUser == null) return;

    TextEditingController itemNameController = TextEditingController(text: item.name);
    TextEditingController itemNotesController = TextEditingController(text: item.notes);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemNameController,
                decoration: const InputDecoration(hintText: 'Item Name'),
              ),
              TextField(
                controller: itemNotesController,
                decoration: const InputDecoration(hintText: 'Notes (Optional)'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (itemNameController.text.isNotEmpty) {
                  try {
                    await _firestore
                        .collection('users')
                        .doc(currentUser!.uid)
                        .collection('items')
                        .doc(item.id)
                        .update({
                          'name': itemNameController.text,
                          'notes': itemNotesController.text.isEmpty ? null : itemNotesController.text,
                        });
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating item: $e')),
                      );
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(TrackingItem item) async {
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('items')
          .doc(item.id)
          .delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item ${item.name} deleted.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting item: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Center(child: Text('Please sign in to manage your items.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Management'),
      ),
      body: StreamBuilder<QuerySnapshot<TrackingItem>>(
        stream: _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('items')
            .withConverter<TrackingItem>(
              fromFirestore: TrackingItem.fromFirestore,
              toFirestore: (item, options) => item.toFirestore(),
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('No tracking items yet. Add one using the + button!'));
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          if (item.notes != null && item.notes!.isNotEmpty)
                            Text(
                              'Notes: ${item.notes}',
                              style: const TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _editItem(item),
                      child: const Text('Edit'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () => _deleteItem(item),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
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
