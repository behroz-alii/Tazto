import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import '../services/ai_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _controller = TextEditingController();
  final List<AppChatMessage> _messages = [];
  late final FoodAIService _aiService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _aiService = FoodAIService(); // Assuming already initialized globally
    _addMessage('👋 Hello, I\'m Tazto AI — your futuristic food assistant.', isUser: false);
  }

  void _addMessage(String text, {required bool isUser}) {
    setState(() => _messages.add(AppChatMessage(text: text, isUser: isUser)));
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final message = _controller.text;
    _controller.clear();
    _addMessage(message, isUser: true);
    setState(() => _isLoading = true);

    try {
      final response = await _aiService.handleQuery(message);
      _addMessage(response, isUser: false);
    } catch (e) {
      _addMessage("⚠️ Sorry, I'm having trouble right now.", isUser: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Futuristic dark theme
      appBar: AppBar(
        title: const Text(
          "🤖 Tazto AI",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) => _ChatBubble(_messages[i]),
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(color: Colors.deepPurple),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.deepPurple.shade700,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppChatMessage {
  final String text;
  final bool isUser;

  AppChatMessage({required this.text, required this.isUser});
}

class _ChatBubble extends StatelessWidget {
  final AppChatMessage message;

  const _ChatBubble(this.message);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          gradient: message.isUser
              ? LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent])
              : LinearGradient(colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade600]),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: message.isUser ? const Radius.circular(18) : const Radius.circular(0),
            bottomRight: message.isUser ? const Radius.circular(0) : const Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
