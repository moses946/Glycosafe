import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:glycosafe_v1/components/profile_picture.dart';
import 'package:glycosafe_v1/providers/themeprovider.dart';
import 'package:glycosafe_v1/pages/db.dart';
import 'package:glycosafe_v1/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/bottomnav.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsOn = false;
  late bool _darkModeOn;

  @override
  void initState() {
    super.initState();
    setState(() {
      _darkModeOn =
          Provider.of<ThemeNotifier>(context, listen: false).isDarkMode;
    });
  }

  void _toggleNotifications() {
    setState(() {
      _notificationsOn = !_notificationsOn;
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _darkModeOn = !_darkModeOn;
      Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
    });
  }

  void _launchURL() async {
    const url = 'https://glycosafe.jhubafrica.com/';
    try {
      await launchUrl(Uri.parse(url));
    } on Exception {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    setState(() {
      _darkModeOn = isDarkMode;
    });
    BoxDecoration lightModeDecoration = BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: _darkModeOn ? Colors.white.withOpacity(0.1) : Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(42, 14, 14, 14),
              blurRadius: 3,
              offset: Offset(0, 2)),
        ]);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Settings",
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: _darkModeOn ? Colors.white : Colors.black)),
      ),
      backgroundColor: _darkModeOn ? Colors.black : Colors.white,
      body: SafeArea(
        child: ListView(children: [
          customProfileWidget(
              context: context,
              darkModeOn: _darkModeOn,
              firstName: appState.firstName,
              lastName: appState.lastName,
              email: appState.email,
              phoneNumber: appState.phoneNumber,
              lightModeDecoration: lightModeDecoration),
          SectionHeaders("My Account"),
          InkWell(
            child: CustomSettingsCard(Icons.person_2_outlined,
                "Personal Information", lightModeDecoration),
            onTap: () {
              Navigator.of(context).pushNamed("/edit_personalInfo");
            },
          ),
          InkWell(
            child: CustomSettingsCard(Icons.password_outlined,
                "Change Password", lightModeDecoration),
            onTap: () {
              Navigator.of(context).pushNamed("/password_reset");
            },
          ),
          SectionHeaders("Preferences"),
          CustomSettingsCardSwitch(
              Icons.notifications_off_outlined,
              Icons.notifications_active_outlined,
              "Turn Off Notifications",
              "Turn On Notifications",
              _notificationsOn,
              _toggleNotifications,
              lightModeDecoration),
          CustomSettingsCardSwitch(
              Icons.light_mode_outlined,
              Icons.dark_mode_outlined,
              "Switch to Light Mode",
              "Switch to Dark Mode",
              _darkModeOn,
              _toggleDarkMode,
              lightModeDecoration),
          SectionHeaders("Support"),
          CustomSettingsCard(
              Icons.policy_outlined, "Privacy Policy", lightModeDecoration),
          CustomSettingsCard(
              Icons.help_center_outlined, "Help Center", lightModeDecoration),
          InkWell(
            onTap: _launchURL,
            child: CustomSettingsCard(
                Icons.info_outlined, "About", lightModeDecoration),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/report_bug');
            },
            child: CustomSettingsCard(
                Icons.bug_report_outlined, "Report a bug", lightModeDecoration),
          ),
          SectionHeaders("Account Actions"),
          InkWell(
            child: CustomSettingsCard(
                Icons.logout_outlined, "Logout", lightModeDecoration),
            onTap: () {
              showDialog(
                  barrierDismissible:
                      false, //prevent dismissing or device navigation
                  context: context,
                  builder: ((context) => AlertDialog.adaptive(
                        backgroundColor: const Color.fromARGB(255, 23, 23, 23),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white.withOpacity(0.6)),
                        ),
                        content: const Text(
                          "Do you really want to log out?",
                          style: TextStyle(
                              color: Color.fromRGBO(91, 88, 77, 1),
                              fontSize: 15),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                _logout(context);
                              },
                              child: const Text("Yes",
                                  style: TextStyle(color: Colors.orange))),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // _logout(context);
                              },
                              child: const Text("No",
                                  style: TextStyle(color: Colors.orange))),
                        ],
                      )));
            },
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("/delete_account");
            },
            child: CustomSettingsCard(Icons.delete_outline_outlined,
                "Delete Account", lightModeDecoration),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "GlycoSafe V1.00",
              style: GoogleFonts.inter(
                  color: const Color.fromRGBO(172, 170, 144, 1),
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 25,
          )
        ]),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  void _logout(BuildContext context) async {
    try {
      EasyLoading.show();
      var appState = Provider.of<MyAppState>(context, listen: false);
      var databaseHelper = DatabaseHelper();
      List<String?> token = await TokenService().getTokens();
      var refreshToken = token[1];
      var url = Endpoints().logout;
      var request = http.Request("post", Uri.parse(url));

      request.body = jsonEncode(<String, String>{
        "refresh": refreshToken!,
      });

      request.headers["Content-Type"] = "applicaton/json; charset=UTF-8";

      var response = await request.send();

      if (response.statusCode == 205) {
        TokenService().deleteToken("access_token");
        TokenService().deleteToken("refresh_token");
        appState.flushDetails();
        appState.logout(2);
        databaseHelper.deleteDatabaseFile();
        EasyLoading.dismiss();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => const Login()));
      } else {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Server Error, Please try again in a few minutes!",
        ));
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

  Widget CustomSettingsCard(IconData prefixIcon, String textContext,
      BoxDecoration lightModeDecoration) {
    var width = MediaQuery.of(context).size.width;
    var icon = prefixIcon;
    var text = textContext;
    return Container(
      margin:
          EdgeInsets.only(left: width * 0.05, right: width * 0.05, bottom: 20),
      // width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      // height: 100,
      decoration: lightModeDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.orange,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                text,
                style: GoogleFonts.roboto(
                    fontSize: 15, color: const Color.fromRGBO(91, 88, 77, 1)),
              ),
            ],
          ),
          const Icon(Icons.chevron_right_rounded,
              color: Color.fromRGBO(113, 110, 110, 1))
        ],
      ),
    );
  }

  Widget CustomSettingsCardSwitch(
      IconData prefixIcon,
      IconData optionalIcon,
      String textContext,
      String textContextOption,
      bool valueMake,
      Function toggleValue,
      BoxDecoration lightModeDecoration) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin:
          EdgeInsets.only(left: width * 0.05, right: width * 0.05, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: lightModeDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                valueMake ? prefixIcon : optionalIcon,
                color: Colors.orange,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(valueMake ? textContext : textContextOption,
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: const Color.fromRGBO(91, 88, 77, 1))),
            ],
          ),
          SizedBox(
            height: 20,
            child: Transform.scale(
              scale: 0.7,
              child: Switch(
                trackOutlineColor: WidgetStateProperty.all(!valueMake
                    ? Colors.orange.withOpacity(0.5)
                    : Colors.transparent),
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: Colors.orange.withOpacity(0.8),
                activeTrackColor: Colors.orange,
                value: valueMake,
                onChanged: (value) {
                  setState(() {
                    toggleValue();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget SectionHeaders(String header) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      margin:
          EdgeInsets.only(left: width * 0.05, right: width * 0.05, bottom: 15),
      child: Text(header,
          style: GoogleFonts.inter(
              fontSize: 18,
              color: const Color.fromRGBO(87, 87, 87, 1),
              fontWeight: FontWeight.bold)),
    );
  }
}

class customProfileWidget extends StatelessWidget {
  const customProfileWidget({
    super.key,
    required this.context,
    required bool darkModeOn,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.lightModeDecoration,
  }) : _darkModeOn = darkModeOn;

  final BuildContext context;
  final bool _darkModeOn;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final BoxDecoration lightModeDecoration;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
        margin: EdgeInsets.only(
            left: width * 0.05, right: width * 0.05, bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: lightModeDecoration,
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.only(right: 25),
                width: 60,
                height: 60,
                child: ProfilePicture(firstName: firstName)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$firstName $lastName",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: _darkModeOn ? Colors.white : Colors.black),
                ),
                Text(
                  email,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(172, 170, 144, 1)),
                ),
                Text(
                  phoneNumber,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(172, 170, 144, 1),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
