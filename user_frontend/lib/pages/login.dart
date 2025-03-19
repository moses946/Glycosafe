import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/pages/db.dart';
import 'package:glycosafe_v1/pages/signup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TokenService tokenService = TokenService();

  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password to continue';
    } else {
      return null;
    }
  }

  // Add try except block to login func

  void loginFunc(BuildContext context) async {
    try {
      EasyLoading.show(status: "Logging you in!");
      if (_formKey.currentState!.validate()) {
        final user = {
          'username': _emailController.text,
          'password': _passwordController.text,
        };

        var url = Endpoints().token;

        final body = jsonEncode(user);

        var request = http.Request("POST", Uri.parse(url));
        request.headers["Content-Type"] = "application/json";
        request.body = body;

        var response = await request.send();

        if (response.statusCode >= 200 && response.statusCode <= 300) {
          var message = await response.stream.bytesToString();
          var accessToken = jsonDecode(message)["access"];
          var refreshToken = jsonDecode(message)["refresh"];
          await initializeDatabase(accessToken);
          EasyLoading.dismiss();

          final TokenService tokenService = TokenService();
          tokenService.saveToken(accessToken, "access_token");
          tokenService.saveToken(refreshToken, "refresh_token");
          Navigator.of(context).pushReplacementNamed("/camera");
        } else {
          if (response.statusCode == 400) {
            EasyLoading.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                content: "The email is not linked to an account."));
          } else if (response.statusCode == 401) {
            EasyLoading.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                content:
                    "Confirm that your email and password are correct and try again."));
          }
        }
      } else {
        EasyLoading.dismiss();
      }
    } on http.ClientException {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Check your internet connection and try again."));
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Server Error! Try again after a few minutes."));
    }
  }

  Future<void> initializeDatabase(String accesstoken) async {
    print("initializing");
    var appState = Provider.of<MyAppState>(context, listen: false);
    DatabaseHelper().database;
    var databaseHelper = DatabaseHelper();
    var url = Endpoints().load_profile_login;
    var request = http.Request("POST", Uri.parse(url));
    request.headers["Authorization"] = "Bearer $accesstoken";
    var accessToken = Jwt.parseJwt(accesstoken);

    request.body = jsonEncode({"user_id": accessToken["user_id"].toString()});
    var response = await request.send();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var message = await response.stream.bytesToString();
      print(message);
      var profileData = jsonDecode(message)["profile"];
      print(profileData);
      List medicationData = jsonDecode(message)["medication"];
      databaseHelper.addProfile(
          userId: profileData["user_id"],
          weight: profileData["weight"].toString(),
          firstName: profileData["first_name"],
          lastName: profileData["last_name"],
          DOB: profileData["date_of_birth"],
          email: profileData["email"],
          phoneNumber: profileData["phone_number"],
          diabetesStatus: profileData["diabetes_status"],
          gender: profileData["gender"],
          diabetesType: profileData["diabetes_type"]);
      if (medicationData.isNotEmpty) {
        for (var medication in medicationData) {
          databaseHelper.addMedication(
              medication_name: medication["medication_name"],
              icon: medication["icon"],
              start_time: medication["start_time"],
              frequency: medication["frequency"],
              dosage: medication["dosage"],
              instruction: medication["instructions"],
              frequency_unit: medication["frequency_unit"],
              medication_id: medication["medication_id"]);
        }
      }

      await appState.setDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 20),
          children: [
            const SizedBox(height: 20),
            SvgPicture.asset(
              "assets/login_svg.svg",
              width: 300,
              height: 250,
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'Welcome Back!',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      labelText: "Email",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    controller: _emailController,
                    validator: _validateEmail,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      labelText: "Password",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      suffixIcon: IconButton(
                        icon: _passwordVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Implement forgot password functionality here
                        Navigator.of(context)
                            .pushReplacementNamed("/forgot_password");
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.orange, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      loginFunc(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      // onPrimary: Colors.white,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      GestureDetector(
                        child: const Text(
                          "Signup",
                          style: TextStyle(color: Colors.orange, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const SignUp()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
