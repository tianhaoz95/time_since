import 'package:flutter/material.dart';
import 'package:time_since/models/tracking_item.dart';
import 'package:time_since/l10n/app_localizations.dart';

class StatusButtons extends StatefulWidget {
  const StatusButtons({
    super.key,
    required this.item,
    required this.onLogNow,
    required this.onAddCustomDate,
    required this.onSchedule,
    this.isOverdue = false,
    this.animationController,
  });

  final TrackingItem item;
  final Function(TrackingItem) onLogNow;
  final Function(TrackingItem) onAddCustomDate;
  final Function(TrackingItem) onSchedule;
  final bool isOverdue;
  final AnimationController? animationController;

  @override
  State<StatusButtons> createState() => _StatusButtonsState();
}

class _StatusButtonsState extends State<StatusButtons> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.animationController != null) {
      _controller = widget.animationController!;
    } else {
      _controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      )..repeat(reverse: true);
    }
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    if (widget.animationController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                decoration: widget.isOverdue
                    ? BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5 * _animation.value),
                            blurRadius: 10.0 * _animation.value,
                            spreadRadius: 5.0 * _animation.value,
                          ),
                        ],
                      )
                    : null,
                child: child,
              );
            },
            child: ElevatedButton(
              onPressed: () => widget.onLogNow(widget.item),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                elevation: 0,
              ),
              child: Text(l10n.logNowButton),
            ),
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
              widget.onAddCustomDate(widget.item);
            } else if (result == 'schedule') {
              widget.onSchedule(widget.item);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'custom_date',
              child: Text(l10n.customDateButton),
            ),
            if (widget.item.repeatDays != null && widget.item.repeatDays! > 0)
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
