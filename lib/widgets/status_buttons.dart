import 'package:flutter/material.dart';
import 'package:time_since/models/tracking_item.dart';

class StatusButtons extends StatelessWidget {
  const StatusButtons({
    super.key,
    required this.item,
    required this.onLogNow,
    required this.onAddCustomDate,
  });

  final TrackingItem item;
  final Function(TrackingItem) onLogNow;
  final Function(TrackingItem) onAddCustomDate;

  @override
  Widget build(BuildContext context) {
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
            child: const Text('Log Now'),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onAddCustomDate(item),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(color: Colors.orange, width: 2.0)),
              elevation: 0,
            ),
            child: const Text('Custom Date'),
          ),
        ),
      ],
    );
  }
}
