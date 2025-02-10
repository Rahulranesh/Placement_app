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
  final String anthropicApiKey =
      "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";

  /// Calls the Anthropic Claude API to get a response.
  Future<String> fetchAIResponse(String userMessage) async {
    // Claude’s API endpoint.
    final url = Uri.parse("https://api.anthropic.com/v1/complete");

    // Construct the prompt with the necessary context.
    // The prompt format uses tokens "Human:" and "Assistant:".
    final String prompt =
        "Human: You are an educational assistant for a placement app. Answer only questions related to academics, placements, education, and career guidance.\n"
        "Human: $userMessage\n"
        "Assistant:";

    // Set up the body of the request.
    final Map<String, dynamic> body = {
      "model": "claude-v1", // or another Claude model if available
      "prompt": prompt,
      "max_tokens_to_sample": 150,
      "temperature": 0.7,
      "stop_sequences": ["\n\nHuman:"]
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        // Anthropic uses the "x-api-key" header to authenticate.
        "x-api-key": anthropicApiKey,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Claude returns the completion in a field called "completion"
      String reply = data["completion"];
      return reply.trim();
    } else {
      throw Exception("Failed to fetch AI response: ${response.body}");
    }
  }

  /// Sends the user's message and fetches the AI response.
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

  /// Builds the UI for a single chat message bubble.
  Widget _buildMessage(ChatMessage message) {
    final bubbleColor =
        message.isUser ? Colors.blueAccent[100] : Colors.grey[300];
    final textColor = message.isUser ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
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
    return Scaffold(
      backgroundColor: baseColor,
      appBar: CustomAppBar(title: "Educational AI Chatbot"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(top: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // Display the most recent message at the bottom.
                final message = _messages[_messages.length - 1 - index];
                return _buildMessage(message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
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
                const SizedBox(width: 10),
                neumorphicButton(
                    onPressed: _sendMessage, child: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
