import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as genai;

class ChatMessagesHistory extends ChangeNotifier {
  List<ChatMessage> messages = [];
  final ChatUser geminiUser = ChatUser(
      id: '0', firstName: "Rafiki", profileImage: "assets/images/rafiki1.jpg");

  ChatMessagesHistory([dynamic model]) {
    if (model != null) {
      initializeMessages(model);
    }
  }

  Future<void> initializeMessages(dynamic model) async {
    print("Initialize messages");

    final content = [genai.Content.text("Hello")];
    var response = await model.generateContent(content);
    print(response.text);

    ChatMessage geminiMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: response.text,
      isMarkdown: true,
    );

    messages = [geminiMessage];
    notifyListeners();
  }

  List<ChatMessage> get messageList => messages;
  ChatUser get aiUser => geminiUser;

  void addMessage(ChatMessage message) {
    messages = [message, ...messages];
    notifyListeners();
  }

  void streamMessage(String text) {
    var lastMessage = messages.removeAt(0);
    var originalText = lastMessage.text;
    var newText = originalText + text;
    ChatMessage streamMessage =
        ChatMessage(createdAt: DateTime.now(), user: geminiUser, text: newText);
    messages = [streamMessage, ...messages];
    notifyListeners();
  }
}
