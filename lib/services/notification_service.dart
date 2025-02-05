import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  final String backendUrl = "http://192.168.109.180:3000/sendNotification";

  Future<void> sendNotificationToTopic(
      String topic, String title, String body) async {
    final url = Uri.parse(backendUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "topic": topic,
        "title": title,
        "body": body,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to send notification: ${response.body}");
    }
  }
}
