import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/pages/forgot_password.dart';
import 'package:glycosafe_v1/pages/password.dart';
import 'package:glycosafe_v1/pages/signup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';

class Confirmation extends StatefulWidget {
  const Confirmation(
      {super.key,
      required this.user,
      required this.lastRoute,
      required this.url});

  final Map user;
  final String lastRoute;
  final String url;

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  final List<TextEditingController> _controllers = [];
  final int _numFields = 4;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    for (int i = 0; i < _numFields; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _collectValues() {
    List<String> values = [];
    for (var controller in _controllers) {
      values.add(controller.text);
    }
    String code = values.join();
    return code; // You can use the values list as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 100, bottom: 20, left: 30, right: 30),
            children: [
              // SizedBox(
              //   height: 30,
              // ),
              const Text("Enter your\nverification code.",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      color: Colors.white)),
              Padding(
                padding: const EdgeInsets.only(
                    top: 40, left: 10, right: 10, bottom: 20),
                child: Form(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      for (int i = 0; i < _numFields; i++)
                        SizedBox(
                          height: 75,
                          width: 55,
                          child: TextFormField(
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                            controller: _controllers[i],
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                contentPadding:
                                    const EdgeInsets.only(top: 30, bottom: 30),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.orange))),
                            // style: Theme.of(context).textTheme.headline6
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            textAlign: TextAlign.center,
                            onChanged: (value) => {
                              if (value.length == 1)
                                {FocusScope.of(context).nextFocus()}
                            },
                          ),
                        ),
                    ])),
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(
                      text: "We sent a confirmation code to your email ",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white),
                      children: [
                    TextSpan(
                        text: widget.user["email"],
                        style: const TextStyle(color: Colors.orange)),
                    const TextSpan(text: '.\nCheck your inbox for the code.')
                  ])),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "This isn't you? ",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  GestureDetector(
                    child: const Text(
                      "Correct your details",
                      style: TextStyle(color: Colors.orange, fontSize: 15),
                    ),
                    onTap: () {
                      _deleteWrongCode(widget.user["email"]);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => widget.lastRoute == "/Personal_Info"
                                ? const SignUp()
                                : ForgotPassword()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    maximumSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    SendConfirmationCode(
                        widget.user["email"], _collectValues());
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ));
  }

  void _deleteWrongCode(String email) async {
    try {
      EasyLoading.show();
      var request =
          http.Request("POST", Uri.parse(Endpoints().delete_reset_code));
      request.body = jsonEncode(<String, String>{"email": email});
      request.headers["Content-Type"] = "application/json";

      await request.send();
      EasyLoading.dismiss();
    } on http.ClientException {
      EasyLoading.dismiss();
      // ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      //     content: "Check your internet connection and try again."));
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      //     content: "Server Error! Try again after a few minutes."));
    }
  }

  void SendConfirmationCode(String email, String code) async {
    try {
      EasyLoading.show();
      var request = http.Request("POST", Uri.parse(widget.url));
      request.body = jsonEncode(<String, String>{"email": email, "code": code});
      request.headers["Content-Type"] = "application/json";

      var response = await request.send();

      var message = await response.stream.bytesToString();
      Map msg = jsonDecode(message);
      if (widget.lastRoute == "/Login") widget.user["code"] = code;
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => PasswordScreen(
                user: widget.user,
                nextRoute: widget.lastRoute,
                url: widget.lastRoute == "/Personal_Info"
                    ? Endpoints().password_signup
                    : Endpoints().reset_password)));
      } else {
        EasyLoading.dismiss();
        print(response.statusCode);
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(content: msg["message"]));
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
}
