import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ChatGPTService _chatGPTService = ChatGPTService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  void _handleSubmitted(String text) {
    if (text.isEmpty || _isLoading) return;
    _textController.clear();
    ChatMessage message = ChatMessage(text: text, isUser: true);
    setState(() {
      _messages.insert(0, message);
      _isLoading = true;
    });
    _getChatGPTResponse(text);
  }

  Future<void> _getChatGPTResponse(String text) async {
    try {
      String response = await _chatGPTService.sendMessage(text);
      ChatMessage botMessage = ChatMessage(text: response, isUser: false);
      setState(() {
        _messages.insert(0, botMessage);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.insert(
          0,
          const ChatMessage(
            text: "Sorry, I encountered an error. Please try again later.",
            isUser: false,
          ),
        );
      });
    }
  }

  void _clearChatHistory() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _clearChatHistory,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, int index) => _messages[index],
              ),
            ),
            if (_isLoading) const LinearProgressIndicator(),
            _buildTextComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: _isLoading ? null : _handleSubmitted,
              enabled: !_isLoading,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed:
                _isLoading
                    ? null
                    : () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({Key? key, required this.text, required this.isUser})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class ChatGPTService {
  final String rapidApiHost =
      'cheapest-gpt-4-turbo-gpt-4-vision-chatgpt-openai-ai-api.p.rapidapi.com';
  final String rapidApiKey =
      '56c4ab2608msh4a5a119def57368p158eb4jsn3af0e4420223';

  Future<String> sendMessage(String message) async {
    final url = Uri.parse('https://$rapidApiHost/v1/chat/completions');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-rapidapi-host': rapidApiHost,
          'x-rapidapi-key': rapidApiKey,
        },
        body: jsonEncode({
          "messages": [
            {"role": "user", "content": message},
          ],
          "model": "gpt-4o",
          "max_tokens": 100,
          "temperature": 0.9,
        }),
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No response';
      } else {
        throw Exception('Failed to fetch response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error communicating with the server: $e');
    }
  }
}
