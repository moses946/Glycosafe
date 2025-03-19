import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/local_notifications.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            LocalNotifications.showSimpleNotification(
                title: "My first notification",
                body: "Notification from Mwai",
                payload: "What does gaga know about cameras");
          },
          child: const Text("Show a notification"),
        ),
      ),
    );
  }
}
