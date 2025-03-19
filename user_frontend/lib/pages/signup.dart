import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/pages/confirmation.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value!.length != 10) {
      return "Enter a valid phone number";
    } else {
      return null;
    }
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

  Future _register() async {
    try {
      EasyLoading.show();
      if (_formKey.currentState!.validate()) {
        final user = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneNumberController.text,
        };
        var request = http.Request("POST", Uri.parse(Endpoints().register));
        request.headers["Content-Type"] = "application/json";
        request.body = jsonEncode({"email": user["email"]});

        var response = await request.send();

        if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          EasyLoading.dismiss();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => Confirmation(
                  user: user,
                  lastRoute: "/Personal_Info",
                  url: Endpoints().verify)));
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Server Error! Try again after a few minutes."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.only(top: 100, bottom: 16, left: 25, right: 25),
          children: [
            SvgPicture.asset(
              "assets/signup_svg.svg",
              width: 300,
              height: 250,
            ),
            const Center(
                child: Text("Let's Get Started",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white))),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                          focusNode: _firstNameFocusNode,
                          controller: _firstNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelText: 'First name',
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: _validateNotEmpty,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_lastNameFocusNode);
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                          focusNode: _lastNameFocusNode,
                          textCapitalization: TextCapitalization.words,
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelText: 'Last name',
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: _validateNotEmpty,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      labelText: 'Email',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_phoneNumberFocusNode);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      focusNode: _phoneNumberFocusNode,
                      controller: _phoneNumberController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        labelText: 'Phone Number',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      validator: _validatePhoneNumber,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _register();
                      }),
                  const SizedBox(height: 25),
                  ElevatedButton(
                      onPressed: () {
                        _register();
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
                        "Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ",
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                GestureDetector(
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.orange, fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("/login");
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
