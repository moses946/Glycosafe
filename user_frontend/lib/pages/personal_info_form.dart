import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/pages/db.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/pages/finalize_signup.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key, required this.user});

  final Map user;

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final PageController _pageController = PageController();
  final _formState = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();

  String _gender = '';
  String _dob = DateFormat("yyyy-MM-dd")
      .format(DateTime.now().subtract(const Duration(days: 7300)));
  String? _diabeticStatus;
  int _currentPage = 0;
  bool _showAdditionalFields = false;
  String? _diabetesType;
  String? ErrorMessage;
  String _weight = "";

  void _selectGender(String gender) {
    setState(() {
      _gender = gender;
    });
    print(_gender);
  }

  void _handleDiabeticStatusChange(String? value) {
    setState(() {
      _diabeticStatus = value!;
      _showAdditionalFields = _diabeticStatus == 'Yes';
    });
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  void _nextPage() {
    if (_currentPage == 0 && _gender.isEmpty) {
      setState(() {
        ErrorMessage = "Please Select your Gender to continue";
      });
      return;
    }

    if (_formState.currentState!.validate()) {
      setState(() {
        _currentPage++;
        _pageController.nextPage(
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
        ErrorMessage = null;
      });
    }
  }

  void _setDate(date) {
    setState(() {
      _dob = date;
    });
  }

  void _submit() async {
    try {
      if (_formState.currentState!.validate()) {
        EasyLoading.show();
        final databaseHelper = DatabaseHelper();

        var diabetesType = _diabetesType ?? "";
        widget.user["gender"] = _gender;
        widget.user["dateOfBirth"] = _dob;
        widget.user["diabetesStatus"] = _diabeticStatus;
        widget.user["diabetesType"] = diabetesType;
        widget.user["weight"] = _weight.toString();

        var url = Endpoints().personal_info;
        var request = http.Request("POST", Uri.parse(url));
        request.body = jsonEncode(widget.user);
        var response = await request.send();

        var message = await response.stream.bytesToString();
        if (response.statusCode >= 200 && response.statusCode < 300) {
          print(widget.user);
          var appState = Provider.of<MyAppState>(context, listen: false);
          var accessToken = jsonDecode(message)["access"];
          var refreshToken = jsonDecode(message)["refresh"];
          var userId = Jwt.parseJwt(accessToken)["user_id"];
          databaseHelper.addProfile(
              userId: userId,
              firstName: widget.user["firstName"],
              lastName: widget.user["lastName"],
              email: widget.user["email"],
              phoneNumber: widget.user["phoneNumber"],
              gender: widget.user["gender"],
              DOB: widget.user["dateOfBirth"],
              weight: widget.user["weight"],
              diabetesStatus: widget.user["diabetesStatus"],
              diabetesType: widget.user["diabetesType"]);

          appState.setDetails();
          final TokenService tokenService = TokenService();
          tokenService.saveToken(accessToken, "access_token");
          tokenService.saveToken(refreshToken, "refresh_token");
          EasyLoading.dismiss();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Final_SignUp()));
        } else {
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
              content: "Server Error! Try again after a few minutes."));
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Form(
          key: _formState,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _genderPage(),
              _birthdatePage(),
              _diabeticPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderPage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 30),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Step 1 of 3",
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Colors.orange)),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Choose your Gender",
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
        ),
        if (ErrorMessage != null) ...[
          const SizedBox(height: 8.0),
          Text(
            ErrorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
        const SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            _selectGender("M");
          },
          child: Column(
            children: [
              ClipOval(
                child: Container(
                  color: _gender == "M"
                      ? const Color.fromARGB(79, 240, 147, 7)
                      : Colors.white.withOpacity(0.4),
                  height: 120,
                  width: 120,
                  child: SvgPicture.asset("assets/male_icon.svg"),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Male",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            _selectGender("F");
          },
          child: Column(
            children: [
              ClipOval(
                child: Container(
                  color: _gender == "F"
                      ? const Color.fromARGB(79, 240, 147, 7)
                      : Colors.white.withOpacity(0.4),
                  height: 120,
                  width: 120,
                  child: SvgPicture.asset("assets/female_icon.svg"),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Female",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: _nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            // onPrimary: Colors.white,
            minimumSize: const Size(150, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Next",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }

  Widget _birthdatePage() {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/birthday.svg'),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Step 2 of 3",
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Colors.orange)),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'What is your current weight?(kg)',
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.white)),
            ),
            TextFormField(
              validator: _validateNotEmpty,
              controller: _weightController,
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
              decoration: InputDecoration(
                  // suffix: ,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "65kg",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1)),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "When were you born?",
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ),
            const SizedBox(
              height: 15,
            ),
            DateTimePickerWidget(
                onChange: (datetime, list) {
                  _dob = DateFormat('yyyy-MM-dd').format(datetime);
                  print('Selected date: $datetime\n, $list');
                },
                onCancel: () {},
                maxDateTime: DateTime.now(),
                initDateTime:
                    DateTime.now().subtract(const Duration(days: 7300)),
                minDateTime: DateTime(1900),
                dateFormat: 'yyyy-MMM-dd',
                pickerTheme: DateTimePickerTheme(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  itemTextStyle: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white)),
                  showTitle: false,
                  cancel: Container(),
                  confirm: Container(),
                )),
            const SizedBox(
              height: 70,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _weight = _weightController.text;
                });
                _nextPage();
                print(_dob);
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
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _diabeticPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Step 3 of 3",
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Colors.orange)),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 15.0, left: 8.0, right: 8.0, bottom: 25),
          child: SvgPicture.asset(
            'assets/diabetes.svg',
            height: 200,
          ),
        ),
        Text(
          'Are you diabetic?',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Colors.white)),
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Radio<String>(
                  value: 'Yes',
                  groupValue: _diabeticStatus,
                  onChanged: _handleDiabeticStatusChange,
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('No', style: TextStyle(color: Colors.white)),
                leading: Radio<String>(
                  value: 'No',
                  groupValue: _diabeticStatus,
                  onChanged: _handleDiabeticStatusChange,
                ),
              ),
            ),
          ],
        ),
        if (_diabeticStatus == "")
          const Text(
            'Please select an option',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 15.0, left: 25, right: 25, bottom: 15),
          child: AnimatedOpacity(
              opacity: _showAdditionalFields ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Visibility(
                visible: _showAdditionalFields,
                child: Column(children: [
                  DropdownButtonFormField<String>(
                    dropdownColor: const Color.fromARGB(255, 34, 34, 34),
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    decoration: const InputDecoration(
                      labelText: 'Type 1/Type 2',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    items: ['Type 1', 'Type 2']
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _diabetesType = value!;
                      });
                    },
                    value: _diabetesType,
                    validator: _showAdditionalFields ? _validateNotEmpty : null,
                  ),
                ]),
              )),
        ),
        ElevatedButton(
          onPressed: () {
            _submit();
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
            "Submit",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        )
      ],
    );
  }
}
