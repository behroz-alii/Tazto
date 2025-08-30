import 'package:flutter/material.dart';
import 'package:tazto/services/ai_service.dart';
import 'package:tazto/services/config.dart';

class AIChatWidget extends StatefulWidget {
  const AIChatWidget({super.key});

  @override
  State<AIChatWidget> createState() => _AIChatWidgetState();
}

class _AIChatWidgetState extends State<AIChatWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  late final FoodAIService _aiService;

  @override
  void initState() {
    super.initState();
    _aiService = FoodAIService();
    FoodAIService.initialize();
    _addInitialMessage();
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _addInitialMessage() {
    _addMessage(
      'Hi! I\'m Tazto AI Assistant. Ask me about:\n'
          '- Order status\n'
          '- Menu items\n'
          '- Dietary restrictions\n'
          '- Promotions',
      isUser: false,
    );
  }

  void _addMessage(String text, {required bool isUser}) {
    setState(() {
      _messages.add({
        "text": text,
        "isUser": isUser,
        "time": DateTime.now(),
      });
    });
  }

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty || _isLoading) return;

    _controller.clear();
    _addMessage(message, isUser: true);
    setState(() => _isLoading = true);

    try {
      final response = await _aiService.handleQuery(message);
      _addMessage(response, isUser: false);
    } catch (e) {
      _addMessage("Sorry, I'm having trouble connecting.", isUser: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close keyboard if open
        if (_textFieldFocusNode.hasFocus) {
          _textFieldFocusNode.unfocus();
        } else {
          // Close the bottom sheet when tapping outside
          Navigator.of(context).pop();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 60,
              height: 6,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Messages list
            Expanded(
              child: GestureDetector(
                onTap: () {}, // Absorb taps in message area
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _ChatBubble(
                      text: msg["text"] as String,
                      isUser: msg["isUser"] as bool,
                    );
                  },
                ),
              ),
            ),
            // Loading indicator
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: CircularProgressIndicator(),
              ),
            // Input area
            GestureDetector(
              onTap: () {}, // Absorb taps in input area
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _textFieldFocusNode,
                        decoration: InputDecoration(
                          hintText: "Ask about your order...",
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.orangeAccent],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrange.withOpacity(0.6),
                              blurRadius: 8,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const _ChatBubble({
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {}, // Absorb taps on bubbles
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            gradient: isUser
                ? const LinearGradient(
                colors: [Colors.orange, Colors.orangeAccent])
                : const LinearGradient(colors: [Colors.white38, Colors.white70]),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: isUser
                    ? Colors.deepOrange.withOpacity(0.4)
                    : Colors.grey.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}