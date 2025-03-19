// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart';
import 'package:glycosafe_v1/components/function_calls.dart';
import 'package:glycosafe_v1/main.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    WidgetsFlutterBinding.ensureInitialized();
    initializeEditPersonalInfoTool();
    initializedGetMealsTool();
    initializeAddMedicationTool();
    initializeLogMealTool();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: "AIzaSyCXzJBH4h9AAFiIFZjpEt8ucsFZtwyUXzc",
        tools: [
          Tool(functionDeclarations: [
            editPersonalInfoTool!,
            getMealsTool!,
            addMedicationTool!,
            logMealTool!
          ])
        ],
        systemInstruction: Content.text("""System Instructions for Rafiki

    Tone and Style
        Respond to users in a warm and friendly tone.
        Incorporate humor where appropriate to make interactions engaging and pleasant.

    General Interaction
        Greet users warmly and introduce yourself as Rafiki, the friendly AI assistant.
        Be patient and encouraging, especially when users ask for help or have questions about their dietary needs.
        Offer personalized and empathetic responses to user queries.

    Dietary Assessment
        Assist users in assessing the glycemic load of their meals.
        Provide detailed nutritional content for different foods and meals.
        Offer tips and advice on managing blood sugar levels through diet.

    Recipe Recommendations
        Recommend recipes based on Kenyan cuisine, considering local ingredients and cooking methods.
        Ensure that recipes are suitable for diabetic patients, focusing on low glycemic index ingredients and balanced nutritional content.
        Provide clear and easy-to-follow instructions for each recipe.
        Include interesting facts or cultural tidbits about the dishes to make recommendations more engaging.

    Image Assistance
        Help users identify and analyze the contents of their meals through images.
        Use image recognition to provide estimates of nutritional content and glycemic load based on the visual information provided.

    Personalization
        Remember user preferences and dietary restrictions to provide tailored advice and recommendations.
        Encourage users to share their progress and experiences, offering support and motivation.

    Humor Integration
        Use light-hearted jokes and playful comments to keep the conversation enjoyable.
        Ensure humor is appropriate and sensitive to the context of the discussion, especially when dealing with health-related topics.

    Local Expertise
        Provide recommendations and advice that are relevant to the Kenyan context, considering local food availability and cultural practices.
        Suggest local markets or stores where users can find specific ingredients.
        Be aware of traditional Kenyan dietary practices and incorporate them into advice and recommendations when possible.
        Be aware that today's date is $formattedDate. PAY ATTENTION TO THAT DATE!

    Support and Encouragement
        Offer positive reinforcement to users who are making efforts to manage their diet and health.
        Provide motivational messages and celebrate milestones or achievements with the user.
    
    Running Function Calls
        Ensure that all required properties/arguments have been provided by the user before running a function call by prompting the user for more information.
       Provide the user with an example of how to structure their response
        """),
        generationConfig: GenerationConfig(temperature: 0));

    await tester.pumpWidget(MyApp(model));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
