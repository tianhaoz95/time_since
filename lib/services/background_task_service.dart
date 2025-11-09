import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    print("Running background check...");
    return Future.value(true);
  });
}

class BackgroundTaskService {
  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true, // Set to false in production
    );

    Workmanager().registerPeriodicTask(
      "periodic-background-check",
      "simplePeriodicTask",
      // The minimum frequency for a periodic task is 15 minutes.
      // Setting it to 5 minutes will result in it running every 15 minutes.
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(minutes: 1),
    );
  }
}