import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_since/models/tracking_item.dart';
import 'package:time_since/widgets/status_buttons.dart';
import 'package:time_since/l10n/app_localizations.dart';
import 'package:time_since/l10n/app_localizations.dart';

void main() {
  group('StatusButtons', () {
    testWidgets('renders Log Now button and dropdown menu', (WidgetTester tester) async {
      bool logNowCalled = false;
      bool addCustomDateCalled = false;
      bool scheduleCalled = false;

      final item = TrackingItem(
        id: '1',
        name: 'Test Item',
        lastDate: DateTime.now(),
        repeatDays: 7,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: StatusButtons(
              item: item,
              onLogNow: (item) {
                logNowCalled = true;
              },
              onAddCustomDate: (item) {
                addCustomDateCalled = true;
              },
              onSchedule: (item) {
                scheduleCalled = true;
              },
            ),
          ),
        ),
      );

      // Verify Log Now button is present
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Log Now'), findsOneWidget);

      // Tap the 3-dot icon to open the dropdown
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Verify Custom Date and Schedule options are present
      expect(find.text('Custom Date'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);

      // Tap Custom Date
      await tester.tap(find.text('Custom Date'));
      await tester.pumpAndSettle();
      expect(addCustomDateCalled, isTrue);

      // Re-open dropdown and tap Schedule
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();
      expect(scheduleCalled, isTrue);
    });

    testWidgets('renders Log Now button and dropdown menu without Schedule option if repeatDays is null', (WidgetTester tester) async {
      bool logNowCalled = false;
      bool addCustomDateCalled = false;
      bool scheduleCalled = false;

      final item = TrackingItem(
        id: '1',
        name: 'Test Item',
        lastDate: DateTime.now(),
        repeatDays: null, // No repeat days
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: StatusButtons(
              item: item,
              onLogNow: (item) {
                logNowCalled = true;
              },
              onAddCustomDate: (item) {
                addCustomDateCalled = true;
              },
              onSchedule: (item) {
                scheduleCalled = true;
              },
            ),
          ),
        ),
      );

      // Verify Log Now button is present
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Log Now'), findsOneWidget);

      // Tap the 3-dot icon to open the dropdown
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Verify Custom Date is present, Schedule is not
      expect(find.text('Custom Date'), findsOneWidget);
      expect(find.text('Schedule'), findsNothing);

      // Tap Custom Date
      await tester.tap(find.text('Custom Date'));
      await tester.pumpAndSettle();
      expect(addCustomDateCalled, isTrue);
      expect(scheduleCalled, isFalse); // Schedule should not have been called
    });
  });
}
