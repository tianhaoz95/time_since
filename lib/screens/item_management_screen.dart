import 'package:flutter/material.dart';
import 'package:time_since/models/tracking_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_since/screens/upgrade_screen.dart';
import 'package:time_since/l10n/app_localizations.dart';
import 'package:lpinyin/lpinyin.dart';

class ItemManagementScreen extends StatefulWidget {
  const ItemManagementScreen({super.key});

  @override
  State<ItemManagementScreen> createState() => _ItemManagementScreenState();
}

class _ItemManagementScreenState extends State<ItemManagementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AppLocalizations? l10n;
  final TextEditingController _repeatDaysController = TextEditingController();
  String _selectedUnit = 'Days';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  User? get currentUser => _auth.currentUser;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _isSearching) {
        setState(() {
          _isSearching = false;
          _searchController.clear();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context);
  }

  @override
  void dispose() {
    _repeatDaysController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _addItem() async {
    if (currentUser == null) return;

    // Fetch user document to check for 'early_adopter' status
    final userDoc = await _firestore.collection('users').doc(currentUser!.uid).get();
    final userType = userDoc.data()?['type'];

    // Check current item count only if not an early adopter
    if (userType != 'early_adopter') {
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
                title: Text(l10n!.upgradeRequiredTitle),
                content: Text(l10n!.upgradeRequiredContent),
                actions: <Widget>[
                  TextButton(
                    child: Text(l10n!.cancelButton),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(l10n!.upgradeButton),
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
    }

    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemNotesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n!.addItemTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(hintText: l10n!.itemNameHint),
              ),
              TextField(
                controller: itemNotesController,
                decoration: InputDecoration(hintText: l10n!.notesOptionalHint),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n!.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(l10n!.addButton),
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
                        SnackBar(content: Text(l10n!.errorAddingItem(e.toString()))),
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

  void _showRepeatDaysDialog(TrackingItem item) {
    _repeatDaysController.text = item.repeatDays != null ? item.repeatDays.toString() : '';
    _selectedUnit = 'Days'; // Reset to default

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n!.setRepeatDaysTitle),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _repeatDaysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: l10n!.repeatDaysHint),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  DropdownButton<String>(
                    value: _selectedUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUnit = newValue!;
                      });
                    },
                    items: <String>['Days', 'Weeks', 'Months', 'Years']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n!.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(l10n!.confirmButton),
              onPressed: () async {
                int? value = int.tryParse(_repeatDaysController.text);
                if (value != null) {
                  int repeatDays = value;
                  switch (_selectedUnit) {
                    case 'Weeks':
                      repeatDays *= 7;
                      break;
                    case 'Months':
                      repeatDays *= 30; // Approximate
                      break;
                    case 'Years':
                      repeatDays *= 365; // Approximate
                      break;
                  }
                  await _updateRepeatDays(item, repeatDays);
                }
                if (mounted) {
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
    if (currentUser == null) return;

    TextEditingController itemNameController = TextEditingController(text: item.name);
    TextEditingController itemNotesController = TextEditingController(text: item.notes);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n!.editItemTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(hintText: l10n!.itemNameHint),
              ),
              TextField(
                controller: itemNotesController,
                decoration: InputDecoration(hintText: l10n!.notesOptionalHint),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n!.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(l10n!.saveButton),
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
                        SnackBar(content: Text(l10n!.errorUpdatingItem(e.toString()))),
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
          SnackBar(content: Text(l10n!.itemDeleted(item.name))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.errorDeletingItem(e.toString()))),
        );
      }
    }
  }

  Future<void> _updateRepeatDays(TrackingItem item, int repeatDays) async {
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('items')
          .doc(item.id)
          .update({'repeatDays': repeatDays});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.repeatDaysUpdated(item.name, repeatDays))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.errorUpdatingRepeatDays(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Center(child: Text(l10n!.pleaseSignIn));
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: l10n!.searchHint,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {}); // Rebuild to update the list
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {}); // Rebuild to filter the list
                },
              )
            : Text(l10n!.itemManagementTitle),
        actions: _isSearching
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                    _searchFocusNode.requestFocus();
                  },
                ),
              ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: StreamBuilder<QuerySnapshot<TrackingItem>>(
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

            var items = snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];

            // Apply search filter
            if (_searchController.text.isNotEmpty) {
              final searchQuery = _searchController.text.toLowerCase();
              items = items.where((item) {
                final itemNameLower = item.name.toLowerCase();
                final itemPinyinLower = PinyinHelper.getPinyin(item.name, separator: "", format: PinyinFormat.WITHOUT_TONE).toLowerCase();
                return itemNameLower.contains(searchQuery) || itemPinyinLower.contains(searchQuery);
              }).toList();
            }

            if (items.isEmpty) {
              return Center(child: Text(l10n!.noTrackingItems));
            }

            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      if (item.notes != null && item.notes!.isNotEmpty)
                        Text(
                          l10n!.notesLabel(item.notes!),
                          style: const TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 48.0, // Adjust width as needed for compactness
                            height: 48.0, // Adjust height as needed for compactness
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0), // Match border radius of other buttons
                              child: Container( // Use Container to apply border
                                decoration: BoxDecoration(
                                  color: Colors.white, // Fill color
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.orange, width: 2.0), // Border color
                                ),
                                child: IconButton(
                                  onPressed: () => _showRepeatDaysDialog(item),
                                  icon: const Icon(Icons.schedule),
                                  color: Colors.orange, // Foreground color
                                  padding: EdgeInsets.zero, // Remove default padding for compactness
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          SizedBox(
                            width: 48.0, // Adjust width as needed for compactness
                            height: 48.0, // Adjust height as needed for compactness
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0), // Match border radius of other buttons
                              child: Container( // Use Container to apply border
                                decoration: BoxDecoration(
                                  color: Colors.white, // Fill color
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.orange, width: 2.0), // Border color
                                ),
                                child: IconButton(
                                  onPressed: () => _editItem(item),
                                  icon: const Icon(Icons.edit),
                                  color: Colors.orange, // Foreground color
                                  padding: EdgeInsets.zero, // Remove default padding for compactness
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          SizedBox(
                            width: 48.0, // Adjust width as needed for compactness
                            height: 48.0, // Adjust height as needed for compactness
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0), // Match border radius of other buttons
                              child: Container( // Use Container to apply border
                                decoration: BoxDecoration(
                                  color: Colors.white, // Fill color
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.orange, width: 2.0), // Border color
                                ),
                                child: Builder(
                                  builder: (BuildContext innerContext) {
                                    return IconButton(
                                      onPressed: () {
                                        final RenderBox button = innerContext.findRenderObject() as RenderBox;
                                        final RenderBox overlay = Overlay.of(innerContext).context.findRenderObject() as RenderBox;
                                        final RelativeRect position = RelativeRect.fromRect(
                                          Rect.fromPoints(
                                            button.localToGlobal(Offset.zero, ancestor: overlay),
                                            button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                                          ),
                                          Offset.zero & overlay.size,
                                        );
                                        showMenu<String>(
                                          context: innerContext,
                                          position: position,
                                          items: <PopupMenuEntry<String>>[
                                            PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Text(l10n!.deleteButton),
                                            ),
                                          ],
                                        ).then((String? result) {
                                          if (result == 'delete') {
                                            _deleteItem(item);
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.more_vert),
                                      color: Colors.orange, // Foreground color
                                      padding: EdgeInsets.zero, // Remove default padding for compactness
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        backgroundColor: Colors.deepOrangeAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}