import 'package:flutter/material.dart';
import 'package:time_since/models/tracking_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_since/widgets/status_buttons.dart';
import 'package:time_since/l10n/app_localizations.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lpinyin/lpinyin.dart';

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
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  User? get currentUser => _auth.currentUser;

  @override
  void initState() {
    super.initState();
    _loadSortOption();
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
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadSortOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentSortOption = prefs.getString('sortOption') ?? 'name';
    });
  }

  void _saveSortOption(String option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortOption', option);
  }

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

  void _onSchedule(TrackingItem item) {
    if (item.repeatDays == null || item.repeatDays! <= 0) return;

    final DateTime nextDueDate = item.lastDate.add(Duration(days: item.repeatDays!));

    final Event event = Event(
      title: l10n!.scheduleEventTitle(item.name),
      description: l10n!.scheduleEventDescription(item.name, item.repeatDays!),
      startDate: nextDueDate,
      endDate: nextDueDate.add(const Duration(hours: 1)), // Event for 1 hour
      allDay: true,
    );

    Add2Calendar.addEvent2Cal(event);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n!.scheduleEventConfirmation(item.name, nextDueDate.toLocal().toString().split(' ')[0]))),
    );
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
            : Text(l10n!.itemStatusTitle),
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
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort),
                  onSelected: (String result) {
                    setState(() {
                      _currentSortOption = result;
                    });
                    _saveSortOption(result);
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'name',
                      child: Row(
                        children: [
                          if (_currentSortOption == 'name')
                            const Icon(Icons.check, size: 20.0),
                          const SizedBox(width: 8.0),
                          Text(l10n!.sortByName),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'lastLoggedDate',
                      child: Row(
                        children: [
                          if (_currentSortOption == 'lastLoggedDate')
                            const Icon(Icons.check, size: 20.0),
                          const SizedBox(width: 8.0),
                          Text(l10n!.sortByLastLoggedDate),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'nextDueDate',
                      child: Row(
                        children: [
                          if (_currentSortOption == 'nextDueDate')
                            const Icon(Icons.check, size: 20.0),
                          const SizedBox(width: 8.0),
                          Text(l10n!.sortByNextDueDate),
                        ],
                      ),
                    ),
                  ],
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
            // Apply sorting
            if (_currentSortOption == 'name') {
              items.sort((a, b) => a.name.compareTo(b.name));
            } else if (_currentSortOption == 'lastLoggedDate') {
              items.sort((a, b) => b.lastDate.compareTo(a.lastDate)); // Sort descending for most recent first
            } else if (_currentSortOption == 'nextDueDate') {
              final List<TrackingItem> itemsWithRepeatDays = [];
              final List<TrackingItem> itemsWithoutRepeatDays = [];

              for (var item in items) {
                if (item.repeatDays != null && item.repeatDays! > 0) {
                  itemsWithRepeatDays.add(item);
                } else {
                  itemsWithoutRepeatDays.add(item);
                }
              }

              itemsWithRepeatDays.sort((a, b) {
                final DateTime nextDueDateA = a.lastDate.add(Duration(days: a.repeatDays!));
                final DateTime nextDueDateB = b.lastDate.add(Duration(days: b.repeatDays!));
                return nextDueDateA.compareTo(nextDueDateB);
              });

              items = [...itemsWithRepeatDays, ...itemsWithoutRepeatDays];
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
                        Builder(
                          builder: (BuildContext context) {
                            final int remainingDays = (item.repeatDays! - DateTime.now().difference(item.lastDate).inDays).clamp(0, item.repeatDays!);
                            final double percentageRemaining = remainingDays / item.repeatDays!;

                            Color progressBarColor;
                            if (percentageRemaining > 0.4) {
                              progressBarColor = Colors.green;
                            } else if (percentageRemaining >= 0.2) {
                              progressBarColor = Colors.yellow;
                            } else {
                              progressBarColor = Colors.red;
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: percentageRemaining,
                                  backgroundColor: Colors.grey[300],
                                  color: progressBarColor,
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  l10n!.repeatDaysProgressRemaining(
                                    ((item.repeatDays! - DateTime.now().difference(item.lastDate).inDays).clamp(0, item.repeatDays!).toDouble() / item.repeatDays! * 100).toInt(),
                                    (item.repeatDays! - DateTime.now().difference(item.lastDate).inDays).clamp(0, item.repeatDays!),
                                    item.repeatDays!,
                                  ),
                                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 10.0),
                      StatusButtons(
                        item: item,
                        onLogNow: _logNow,
                        onAddCustomDate: _addCustomDate,
                        onSchedule: _onSchedule,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}