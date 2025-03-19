import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/pages/login.dart';
import 'package:glycosafe_v1/pages/personal_info_form.dart';
import 'package:http/http.dart' as http;

class PasswordScreen extends StatefulWidget {
  const PasswordScreen(
      {super.key,
      required this.user,
      required this.nextRoute,
      required this.url});

  final Map user;
  final String url;
  final String nextRoute;
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  late StatefulWidget nextPage;

  @override
  void initState() {
    super.initState();
    nextPage = widget.nextRoute == "/Personal_Info"
        ? PersonalInfo(user: widget.user)
        : const Login();
  }

  Future _submit() async {
    try {
      EasyLoading.show();
      if (_formKey.currentState!.validate()) {
        print('Password set: ${_passwordController.text}');
        var url = widget.url;
        var userPass = {
          "email": widget.user["email"],
          "password": _passwordController.text
        };

        if (widget.user.containsKey("code")) {
          userPass["code"] = widget.user["code"];
        }

        var request = http.Request("POST", Uri.parse(url));
        request.body = jsonEncode(userPass);
        request.headers["Content-Type"] = "application/json";
        var response = await request.send();

        if (response.statusCode == 200) {
          EasyLoading.dismiss();
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => nextPage));
          if (nextPage == "/Login") {
            ScaffoldMessenger.of(context).showSnackBar(
                ErrorSnackBar(content: "Password reset successfully"));
          }

          //
        } else {
          EasyLoading.dismiss();
        }
      }
    } on http.ClientException {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Check your internet connection and try again."));
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Server Error! Try again after a few minutes."));
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Set your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: SvgPicture.asset(
                    'assets/mdi_key-star.svg',
                    width: 120,
                    height: 120,
                  )),
                  const SizedBox(height: 20),
                  const Text(
                    'Create a strong password by using a mix of letters, numbers and special characters.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter New Password',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      hintText: 'Confirm Password',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: !_confirmPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.white),
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
