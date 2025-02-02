// chat_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  final String apiKey = "YOUR_API_KEY";

  Future<String> fetchAIResponse(String userMessage) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content":
              "You are an educational assistant for a placement app. Answer only questions related to academics, placements, education, and career guidance."
        },
        {"role": "user", "content": userMessage},
      ],
      "temperature": 0.7,
      "max_tokens": 150,
    };
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String reply = data["choices"][0]["message"]["content"];
      return reply.trim();
    } else {
      throw Exception("Failed to fetch AI response: ${response.body}");
    }
  }

  void _sendMessage() async {
    final userInput = _controller.text;
    if (userInput.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: userInput, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    try {
      final aiReply = await fetchAIResponse(userInput);
      setState(() {
        _messages.add(ChatMessage(text: aiReply, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
            text: "Error: Unable to get response. Please try again.",
            isUser: false));
        _isLoading = false;
      });
    }
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: NeumorphicContainer(
          padding: EdgeInsets.all(12),
          child: Text(message.text, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: baseColor,
      appBar: CustomAppBar(title: "Educational AI Chatbot"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: NeumorphicTextField(
                    label: "Enter your question...",
                    onSaved: (value) {},
                  ),
                ),
                SizedBox(width: 10),
                neumorphicButton(
                    onPressed: _sendMessage, child: Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
