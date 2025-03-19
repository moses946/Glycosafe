import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/bottomnav.dart';
import 'package:glycosafe_v1/providers/chatmessage_provider.dart';
import 'package:glycosafe_v1/components/function_calls.dart';
import 'package:glycosafe_v1/providers/themeprovider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as genai;
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';

class RafikiPage extends StatefulWidget {
  final genai.GenerativeModel model;
  RafikiPage({super.key, required this.model});

  @override
  State<RafikiPage> createState() => _RafikiPageState();
}

class _RafikiPageState extends State<RafikiPage> {
  late ChatUser currentUser;
  ChatUser geminiUser = ChatUser(
      id: '0', firstName: "Rafiki", profileImage: "assets/images/rafiki1.jpg");
  var chatSession;
  bool isChatSessionInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeChatSession();
  }

  Future<void> _initializeChatSession() async {
    final model = widget.model;
    chatSession = model.startChat(); // Assuming this is asynchronous
    setState(() {
      isChatSessionInitialized = true;
    });
  }

  genai.ChatSession _reInitializeChat(
      List<genai.Content>? history, chatSession) {
    final model = widget.model;
    List<genai.Content>? newHistory = history;
    print("re-initializing chat with history");
    print(newHistory!.length);
    var newChatSession = model.startChat(history: newHistory);
    setState() {}
    return newChatSession;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.read<MyAppState>();
    currentUser = ChatUser(id: '1', firstName: appState.firstName);
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: GradientText(
            'Rafiki',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
            gradientType: GradientType.linear,
            gradientDirection: GradientDirection.ttb,
            radius: .4,
            colors: [
              Colors.orange,
              Colors.orange,
              isDarkMode ? Colors.white : Colors.black,
            ],
          ),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(child: _chatBody()),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _chatBody() {
    // this returns a widget that holds all the messages i.e from gemini and the user
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final messages = Provider.of<ChatMessagesHistory>(context).messages;
    print(isDarkMode);
    return DashChat(
        messageOptions: isDarkMode
            ? MessageOptions(
                markdownStyleSheet: MarkdownStyleSheet(
                    h1: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    p: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    listBullet: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
                containerColor: const Color.fromRGBO(77, 77, 77, 0.9),
                currentUserContainerColor:
                    const Color.fromRGBO(249, 168, 37, 0.5),
                textColor: Colors.white)
            : const MessageOptions(
                containerColor: Color.fromRGBO(0, 0, 0, 0.6),
                currentUserContainerColor: Color.fromRGBO(249, 168, 37, 1),
                textColor: Colors.white),
        inputOptions: isDarkMode
            ? InputOptions(
                inputTextStyle: const TextStyle(color: Colors.white),
                inputDecoration: defaultInputDecoration(
                    hintText: "Ask me anything ...",
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey),
                    fillColor: const Color.fromRGBO(95, 95, 95, 0.6)))
            : InputOptions(
                inputTextStyle: const TextStyle(color: Colors.white),
                inputDecoration: defaultInputDecoration(
                    hintText: "Ask me anything ...",
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white70),
                    fillColor: const Color.fromRGBO(0, 0, 0, 0.6))),
        currentUser: currentUser,
        onSend: onSend,
        messages: messages);
  }

  void onSend(ChatMessage chatMessage) async {
    var safe = true;
    // chatMessage is the message being sent by the user

    var messageProvider =
        Provider.of<ChatMessagesHistory>(context, listen: false);
    messageProvider.addMessage(chatMessage);
    try {
      final content = genai.Content.text(chatMessage.text);
      var response = await chatSession.sendMessage(content);
      print("checking if there's a function call");
      print("Feedback: ${response.candidates[0].finishReason}");
      // checking safety ratings

      if (response.candidates[0].finishReason == genai.FinishReason.safety) {
        safe = false;
      }
      // for (SafetyRating rating in response.promptFeedback.safetyRatings){
      //   print("rating ${rating.probability.toString()}");
      //     if (rating.probability.toString() != HarmProbability.negligible.toString()){
      //           safe= false;
      //     }
      // }

      if (safe) {
        final functionCalls = response.functionCalls.toList();
        if (functionCalls.isNotEmpty) {
          print(functionCalls);
          print(chatSession);
          // ChatMessage geminiMessage = ChatMessage(
          //   user: geminiUser,
          //   createdAt: DateTime.now(),
          //   text: response.text,
          //   isMarkdown: true);
          // messageProvider.addMessage(geminiMessage);

          final functionCall = functionCalls.first;
          print(functionCall.name);
          final result = await handleFunctionCall(functionCall);
          response = await chatSession.sendMessage(
              genai.Content.functionResponse(functionCall.name, result));
        }
        if (response.text case final text?) {
          print(chatSession.history.toList());
          print(text);
        }

        ChatMessage geminiMessage = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response.text,
            isMarkdown: true);
        messageProvider.addMessage(geminiMessage);
        // await for (final chunk in response) {
        //   print(chunk.text);
        //   messageProvider.streamMessage(chunk.text);
        // }
      } else {
        ChatMessage geminiMessage = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: "Seems i cannot answer that, try somethingelse",
            isMarkdown: true);
        messageProvider.addMessage(geminiMessage);
        print(chatSession.history);
        print(chatSession.history.toList().length);
        print(chatSession.history.toList()[0].parts[0].text);
        var oldHistory = chatSession.history
            .toList()
            .sublist(0, chatSession.history.length - 1);
        oldHistory
            .add(genai.Content("model", [genai.TextPart(chatMessage.text)]));
        chatSession = _reInitializeChat(oldHistory, chatSession);
      }
    } catch (e) {
      print("No function call:$e");
    }
  }

  Future<dynamic> handleFunctionCall(genai.FunctionCall functionCall) async {
    var appState = Provider.of<MyAppState>(context, listen: false);
    final Object result;

    switch (functionCall.name) {
      case 'editPersonalInfo':
        result = EditInfo(functionCall.args, appState);
        break;
      case 'getMeals':
        result = await getMeals(functionCall.args, appState);
        break;
      case 'addMedication':
        result = addMedication(functionCall.args);
        break;
      case 'logMeal':
        appState.setCurrentPage(context, 2);
        result = "Navigated to camera page";
        break;
      default:
        throw UnimplementedError(
            'Function not implemented: ${functionCall.name}');
    }

    return result;
  }
}
