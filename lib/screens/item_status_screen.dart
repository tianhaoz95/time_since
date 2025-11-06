import 'package:flutter/material.dart';
import 'package:time_since/models/tracking_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_since/widgets/status_buttons.dart';
import 'package:time_since/l10n/app_localizations.dart';

class ItemStatusScreen extends StatefulWidget {
  const ItemStatusScreen({super.key});

  @override
  State<ItemStatusScreen> createState() => _ItemStatusScreenState();
}

class _ItemStatusScreenState extends State<ItemStatusScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AppLocalizations? l10n;
  String _currentSortOption = 'name'; // Default sort option

  User? get currentUser => _auth.currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context);
  }

  String _getTimeSince(DateTime lastDate, AppLocalizations l10n) {
    final Duration difference = DateTime.now().difference(lastDate);

    if (difference.inDays > 365) {
      final int years = (difference.inDays / 365).floor();
      return l10n.yearsAgo(years);
    } else if (difference.inDays > 30) {
      final int months = (difference.inDays / 30).floor();
      return l10n.monthsAgo(months);
    } else if (difference.inDays > 0) {
      return l10n.daysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return l10n.hoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return l10n.minutesAgo(difference.inMinutes);
    } else {
      return l10n.justNow;
    }
  }

  void _logNow(TrackingItem item) async {
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('items')
          .doc(item.id)
          .update({'lastDate': Timestamp.fromDate(DateTime.now())});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.loggedNowFor(item.name))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.errorLoggingDate(e.toString()))),
        );
      }
    }
  }

  void _addCustomDate(TrackingItem item) async {
    if (currentUser == null) return;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      try {
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('items')
            .doc(item.id)
            .update({'lastDate': Timestamp.fromDate(pickedDate)});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n!.customDateAddedFor(item.name))),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n!.errorAddingCustomDate(e.toString()))),
          );
        }
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
        title: Text(l10n!.itemStatusTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (String result) {
              setState(() {
                _currentSortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'name',
                child: Text(l10n!.sortByName), // Will add this localization key
              ),
              PopupMenuItem<String>(
                value: 'lastLoggedDate',
                child: Text(l10n!.sortByLastLoggedDate), // Will add this localization key
              ),
            ],
          ),
        ],
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

          // Apply sorting
          if (_currentSortOption == 'name') {
            items.sort((a, b) => a.name.compareTo(b.name));
          } else if (_currentSortOption == 'lastLoggedDate') {
            items.sort((a, b) => b.lastDate.compareTo(a.lastDate)); // Sort descending for most recent first
          }

          if (items.isEmpty) {
            return Center(child: Text(l10n!.noTrackingItemsManageTab));
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                l10n!.lastLogged(item.lastDate.toLocal().toString().split(' ')[0], _getTimeSince(item.lastDate, l10n!)),
                                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                              ),
                              if (item.notes != null && item.notes!.isNotEmpty)
                                Text(
                                  l10n!.notesLabel(item.notes!),
                                  style: const TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (item.repeatDays != null && item.repeatDays! > 0) ...[
                      const SizedBox(height: 8.0),
                      LinearProgressIndicator(
                        value: (DateTime.now().difference(item.lastDate).inDays / item.repeatDays!).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[300],
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        l10n!.repeatDaysProgress(
                          DateTime.now().difference(item.lastDate).inDays,
                          item.repeatDays!,
                          ((DateTime.now().difference(item.lastDate).inDays / item.repeatDays!) * 100).toInt(),
                        ),
                        style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                    const SizedBox(height: 10.0),
                    StatusButtons(
                      item: item,
                      onLogNow: _logNow,
                      onAddCustomDate: _addCustomDate,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}