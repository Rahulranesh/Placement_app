import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';

/// A simple model representing a chat message.
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

  // Replace with your Anthropic API key for Claude.
  final String anthropicApiKey = "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";

  Future<String> fetchAIResponse(String userMessage) async {
    final url = Uri.parse("https://api.anthropic.com/v1/complete");
    final String prompt =
        "Human: You are an educational assistant for a placement app. Answer only questions related to academics, placements, education, and career guidance.\n"
        "Human: $userMessage\n"
        "Assistant:";

    final Map<String, dynamic> body = {
      "model": "claude-v1",
      "prompt": prompt,
      "max_tokens_to_sample": 150,
      "temperature": 0.7,
      "stop_sequences": ["\n\nHuman:"]
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-api-key": anthropicApiKey,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String reply = data["completion"];
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
    final bubbleColor = message.isUser ? Colors.blueAccent[100] : Colors.grey[300];
    final textColor = message.isUser ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: NeumorphicContainer(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.all(12),
          child: Text(message.text,
              style: TextStyle(fontSize: 16, color: textColor)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      // As a modal bottom sheet, no Scaffold/AppBar is used.
      padding: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Chat with AI", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            height: 300,
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(top: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessage(message);
              },
            ),
          ),
          if (_isLoading)
            Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: NeumorphicTextField(
                    label: "Enter your question...",
                    onSaved: (value) {},
                    controller: _controller,
                  ),
                ),
                SizedBox(width: 10),
                neumorphicButton(
                    onPressed: _sendMessage, child: Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
