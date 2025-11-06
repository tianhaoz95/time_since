import 'package:flutter/material.dart';
import 'package:time_since/models/tracking_item.dart';
import 'package:time_since/l10n/app_localizations.dart';

class StatusButtons extends StatelessWidget {
  const StatusButtons({
    super.key,
    required this.item,
    required this.onLogNow,
    required this.onAddCustomDate,
    required this.onSchedule,
  });

  final TrackingItem item;
  final Function(TrackingItem) onLogNow;
  final Function(TrackingItem) onAddCustomDate;
  final Function(TrackingItem) onSchedule;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => onLogNow(item),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              elevation: 0,
            ),
            child: Text(l10n.logNowButton),
          ),
        ),
        const SizedBox(width: 8.0),
        PopupMenuButton<String>(
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.orange, width: 2.0),
            ),
            padding: const EdgeInsets.all(8.0), // Adjust padding to control size
            child: const Icon(Icons.more_vert, color: Colors.orange),
          ),
          onSelected: (String result) {
            if (result == 'custom_date') {
              onAddCustomDate(item);
            } else if (result == 'schedule') {
              onSchedule(item);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'custom_date',
              child: Text(l10n.customDateButton),
            ),
            if (item.repeatDays != null && item.repeatDays! > 0)
              PopupMenuItem<String>(
                value: 'schedule',
                child: Text(l10n.scheduleButton),
              ),
          ],
        ),
      ],
    );
  }
}
