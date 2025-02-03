import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  // Replace with your actual FCM server key.
  static const String serverKey = "YOUR_SERVER_KEY_HERE";

  /// Sends a notification to a given topic (e.g., "students")
  Future<void> sendNotificationToTopic(String topic, String title, String body) async {
    final url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$serverKey",
    };

    final payload = {
      "to": "/topics/$topic",
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      }
    };

    final response = await http.post(url, headers: headers, body: json.encode(payload));
    if (response.statusCode != 200) {
      throw Exception("Failed to send notification: ${response.body}");
    }
  }
}
