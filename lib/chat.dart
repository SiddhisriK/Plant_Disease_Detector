import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  late GenerativeModel _model;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // 🔑 Replace with your actual API key
    const apiKey = "AIzaSyCfr1aJKb9wzXoucCwzVFNZsbQlH353XZg";

    // ✅ Use a safe, compatible Gemini model
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', // Works for most SDK versions
      apiKey: apiKey,
    );
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": userMessage});
      _controller.clear();
      _isLoading = true;
    });

    try {
      // 🧠 Ask Gemini
      final response = await _model.generateContent([Content.text(userMessage)]);
      final botReply = response.text ?? "Sorry, I couldn’t understand that.";

      setState(() {
        _messages.add({"role": "bot", "text": botReply});
      });
    } catch (e) {
      // 🧩 Model fallback if version fails
      if (e.toString().contains('model not found')) {
        try {
          final fallbackModel = GenerativeModel(
            model: 'gemini-1.5-pro-latest',
            apiKey: "YOUR_API_KEY_HERE",
          );
          final response =
              await fallbackModel.generateContent([Content.text(userMessage)]);
          final botReply = response.text ?? "Sorry, I couldn’t understand that.";
          setState(() {
            _messages.add({"role": "bot", "text": botReply});
          });
        } catch (err) {
          setState(() {
            _messages.add({
              "role": "bot",
              "text": "⚠️ Model error: ${err.toString()}"
            });
          });
        }
      } else {
        setState(() {
          _messages.add({"role": "bot", "text": "⚠️ Error: ${e.toString()}"});
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA9DBCA),
        title: const Text(
          'Kisan Mitra 🌿',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["role"] == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF4F9D69).withOpacity(0.3)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft:
                            isUser ? const Radius.circular(16) : Radius.zero,
                        bottomRight:
                            isUser ? Radius.zero : const Radius.circular(16),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message["text"] ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F8F6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF4F9D69),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
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
