import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotifPage extends StatefulWidget {
  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final response =
        await http.get(Uri.parse('http://192.168.8.171:3001/notifications'));

    if (response.statusCode == 200) {
      setState(() {
        notifications = json.decode(response.body);
      });
    } else {
      // Handle error
      print('Failed to load notifications');
    }
  }

  void _showNotificationDetail(BuildContext context, dynamic notification) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NotificationDetailPage(notification: notification),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF9AD4A6),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            color: Color(0xFF9AD4A6), // Green color for the card
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          notification['message'],
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _showNotificationDetail(context, notification),
                    child: Text(
                      'Check',
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4F6E56), // Button color
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationDetailPage extends StatelessWidget {
  final dynamic notification;

  NotificationDetailPage({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Detail'),
        backgroundColor: Color(0xFF9AD4A6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            Text(
              notification['message'],
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
