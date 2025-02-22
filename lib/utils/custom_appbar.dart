import 'package:flutter/material.dart';
import 'package:place/screen/chat_screen.dart';
import 'package:place/services/notification_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotificationButton;
  
  CustomAppBar({required this.title, this.showNotificationButton = false});

  void _showNotificationDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Send Notification"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: messageController,
                decoration: InputDecoration(labelText: "Message"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Send"),
              onPressed: () async {
                String notifTitle = titleController.text.trim();
                String notifMessage = messageController.text.trim();
                if (notifTitle.isNotEmpty && notifMessage.isNotEmpty) {
                  try {
                    // Replace "students" with your target topic.
                    await NotificationService().sendNotificationToTopic("students", notifTitle, notifMessage);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Notification sent successfully"))
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to send notification: $e"))
                    );
                  }
                }
              },
            ),
          ],
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    List<Widget> actionsList = [];
    // Chat icon now opens as a modal bottom sheet.
    actionsList.add(
      IconButton(
        icon: Icon(Icons.chat),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => ChatScreen(),
          );
        },
      ),
    );
    
    if (showNotificationButton) {
      actionsList.add(
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () => _showNotificationDialog(context),
        )
      );
    }
    
    return AppBar(
      title: Text(title),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      actions: actionsList,
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
  