import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/providers/camera_provider.dart';
import 'package:glycosafe_v1/providers/meal_provider.dart';
import 'package:glycosafe_v1/pages/splash.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:glycosafe_v1/providers/chatmessage_provider.dart';
import 'package:glycosafe_v1/components/function_calls.dart';
import 'package:glycosafe_v1/components/local_notifications.dart';
import 'package:glycosafe_v1/providers/medications_provider.dart';
import 'package:glycosafe_v1/providers/themeprovider.dart';
import 'package:glycosafe_v1/pages/camera.dart';
import 'package:glycosafe_v1/pages/community.dart';
import 'package:glycosafe_v1/pages/delete_account.dart';
import 'package:glycosafe_v1/pages/forgot_password.dart';
import 'package:glycosafe_v1/pages/history.dart';
import 'package:glycosafe_v1/pages/home.dart';
import 'package:glycosafe_v1/pages/home_new.dart';
import 'package:glycosafe_v1/pages/login.dart';
import 'package:glycosafe_v1/pages/medications.dart';
import 'package:glycosafe_v1/pages/password_reset.dart';
import 'package:glycosafe_v1/pages/personal_info_settings.dart';
import 'package:glycosafe_v1/pages/rafiki.dart';
import 'package:glycosafe_v1/pages/report_bug.dart';
import 'package:glycosafe_v1/pages/settings%20.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => MyAppState()),
        ChangeNotifierProvider(create: (context) => MealProvider()),
        ChangeNotifierProvider(create: (context) => ChatMessagesHistory(model)),
        ChangeNotifierProvider(
          create: (context) => MedicationProvider(),
        ),
        ChangeNotifierProvider(create: (context) => CameraProvider())
      ],
      child: MyApp(model),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.orange
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  final GenerativeModel model;
  const MyApp(this.model, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TokenService _tokenService = TokenService();
  bool _isLoading = true;
  bool _isAuthenticated = false;
  late CameraProvider cameraProvider;

  @override
  void initState() {
    super.initState();
    try {
      _checkToken();
    } on http.ClientException {
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Check your internet connection and try again!"));
    } on http.Client {
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Check your internet connection and try again!"));
    } on Exception {
      ScaffoldMessenger.of(context)
          .showSnackBar(ErrorSnackBar(content: "Error: Restart Application"));
    }
  }

  Future<void> _checkToken() async {
    List<String?> tokens = await _tokenService.getTokens();

    if (tokens.isEmpty) {
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    } else {
      await Provider.of<MyAppState>(context, listen: false).setDetails();
      await Provider.of<MealProvider>(context, listen: false).getTodayMeals();
      cameraProvider = Provider.of<CameraProvider>(context, listen: false);

      setState(() {
        _isAuthenticated = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: _isLoading
        //     ? SplashScreen()
        //     : (_isAuthenticated
        //         ? CameraPage(cameraController: cameraProvider.cameraController)
        //         : Login()),
        // home: const HomePage2(),
        home: CameraPage(cameraController: cameraProvider.cameraController),
        // home: Final_SignUp(),
        // home: SettingsPage(),
        builder: EasyLoading.init(),
        title: "GlycoSafe",
        theme: ThemeData(
            timePickerTheme: const TimePickerThemeData(
                cancelButtonStyle: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(
                        TextStyle(color: Colors.orange))),
                confirmButtonStyle: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(
                        TextStyle(color: Colors.orange)))),
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(239, 108, 0, 1)),
            useMaterial3: true),
        routes: {
          "/home": (context) => const homeDashboard(),
          "/home2": (context) => const HomePage2(),
          "/camera": (context) =>
              CameraPage(cameraController: cameraProvider.cameraController),
          "/settings": (context) => const SettingsPage(),
          "/community": (context) => const CommunityPage(),
          "/rafiki": (context) => RafikiPage(model: widget.model),
          "/history": (context) => const History(),
          "/password_reset": (context) => const PasswordResetScreen(),
          "/edit_personalInfo": (context) => const EditPersonalInfo(),
          "/medications": (context) => const Medications(),
          "/forgot_password": (context) => ForgotPassword(),
          "/report_bug": (context) => const ReportBug(),
          "/login": (context) => const Login(),
          "/delete_account": (context) => const DeleteAccount(),
        });
  }
}
