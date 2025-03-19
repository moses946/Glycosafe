import 'dart:convert';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/components/mealcard_widget.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:glycosafe_v1/emptymeals.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/bottomnav.dart';
import 'package:glycosafe_v1/components/labeledImage.dart';
import 'package:glycosafe_v1/components/profile_picture.dart';
import 'package:glycosafe_v1/providers/themeprovider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../providers/meal_provider.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  bool _showMacros = false;
  bool _emptyMeal = false;
  String displayDate = "Today";
  DateTime dateDateTime = DateTime.now();
  DateTime today = DateTime.now();
  bool _isButtonDisabled = true;
  List mealData = [];
  bool _isToday = true;

  @override
  void initState() {
    super.initState();
    var mealProvider = context.read<MealProvider>();

    setState(() {
      mealData = mealProvider.mealData;
    });
  }

  void _toggleMacros() {
    setState(() {
      _showMacros = !_showMacros;
    });
  }

  Future<void> _getDate() async {
    DateTime? date;
    date = await showDatePickerDialog(
      context: context,
      initialDate: DateTime.now(),
      minDate: DateTime(2020, 10, 10),
      maxDate: DateTime.now(),
      width: 300,
      height: 300,
      currentDate: DateTime.now(),
      selectedDate: DateTime.now(),
      currentDateDecoration: const BoxDecoration(),
      currentDateTextStyle: const TextStyle(),
      daysOfTheWeekTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      disabledCellsTextStyle: const TextStyle(color: Colors.grey),
      enabledCellsDecoration: const BoxDecoration(),
      enabledCellsTextStyle: const TextStyle(),
      initialPickerType: PickerType.days,
      selectedCellDecoration: const BoxDecoration(color: Colors.green),
      selectedCellTextStyle: const TextStyle(color: Colors.white),
      leadingDateTextStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      slidersColor: Colors.orange[600],
      highlightColor: Colors.redAccent,
      slidersSize: 20,
      splashColor: Colors.lightBlueAccent,
      splashRadius: 40,
      centerLeadingDate: true,
    );
    date ??= DateTime.now();
    var formatedDate = DateFormat("yyyy-MMMM-dd").format(date);
    var yesterday = DateFormat("yyyy-MMMM-dd")
        .format(DateTime.now().subtract(const Duration(days: 1)));
    setState(() {
      dateDateTime = date!;
    });
    if (formatedDate == DateFormat("yyyy-MMMM-dd").format(DateTime.now())) {
      setState(() {
        displayDate = "Today";
        _isButtonDisabled = true;
      });
    } else if (formatedDate == yesterday) {
      setState(() {
        displayDate = "Yesterday";
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        displayDate = DateFormat("MMMM-dd").format(dateDateTime);
        _isButtonDisabled = false;
      });
    }
    _getMeals(dateDateTime);
  }

  void previousDay() {
    setState(() {
      dateDateTime = dateDateTime.subtract(const Duration(days: 1));
    });
    var formatedDate = DateFormat("yyyy-MMMM-dd").format(dateDateTime);
    var yesterday = DateFormat("yyyy-MMMM-dd")
        .format(DateTime.now().subtract(const Duration(days: 1)));
    if (formatedDate == DateFormat("yyyy-MMMM-dd").format(DateTime.now())) {
      setState(() {
        displayDate = "Today";
        _isButtonDisabled = true;
      });
    } else if (formatedDate == yesterday) {
      setState(() {
        displayDate = "Yesterday";
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        displayDate = DateFormat("MMMM-dd").format(dateDateTime);
        _isButtonDisabled = false;
      });
    }
    _getMeals(dateDateTime);
  }

  void nextDay() {
    setState(() {
      dateDateTime = dateDateTime.add(const Duration(days: 1));
    });
    var formatedDate = DateFormat("yyyy-MMMM-dd").format(dateDateTime);
    var yesterday = DateFormat("yyyy-MMMM-dd")
        .format(DateTime.now().subtract(const Duration(days: 1)));
    if (formatedDate == DateFormat("yyyy-MMMM-dd").format(DateTime.now())) {
      setState(() {
        displayDate = "Today";
        _isButtonDisabled = true;
      });
    } else if (formatedDate == yesterday) {
      setState(() {
        displayDate = "Yesterday";
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        displayDate = DateFormat("MMMM-dd").format(dateDateTime);
        _isButtonDisabled = false;
      });
    }
    _getMeals(dateDateTime);
  }

  void _getMeals(DateTime date) async {
    var mealProvider = Provider.of<MealProvider>(context, listen: false);
    print(date);
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      setState(() {
        mealData = mealProvider.mealData;
        _emptyMeal = false;
        _isToday = true;
      });
    } else {
      try {
        EasyLoading.show(status: "Querying meals");
        var tokens = await TokenService().getTokens();
        var formattedDate = DateFormat("yyyy-MM-dd").format(date);
        var accessToken = tokens[0];
        var userId = Jwt.parseJwt(accessToken!)["user_id"].toString();
        var url = "${Endpoints().get_meals}$userId?date=$formattedDate";
        var request = http.Request("GET", Uri.parse(url));
        request.headers["Authorization"] = "Bearer $accessToken";

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          var data = jsonDecode(response.body);
          if (data.containsKey("detail")) {
            if (data["detail"] == "No meals found for the given date.") {
              setState(() {
                _emptyMeal = true;
              });
              EasyLoading.dismiss();
            }
          } else {
            print(data);
            setState(() {
              mealData = [];
              mealData.add(data);
              _emptyMeal = false;
              _isToday = false;
            });

            EasyLoading.dismiss();
          }
        } else {
          EasyLoading.dismiss();
          setState(() {
            dateDateTime = DateTime.now();
            displayDate = "Today";
            _isButtonDisabled = true;
            mealData = mealProvider.mealData;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
            content: "${response.statusCode}: Error from the server",
          ));
        }
      } on http.ClientException {
        EasyLoading.dismiss();
        setState(() {
          dateDateTime = DateTime.now();
          displayDate = "Today";
          _isButtonDisabled = true;
          mealData = mealProvider.mealData;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
            content: "Check your internet connection and try again."));
      } catch (e) {
        print(e);
        EasyLoading.dismiss();
        setState(() {
          dateDateTime = DateTime.now();
          displayDate = "Today";
          _isButtonDisabled = true;
          mealData = mealProvider.mealData;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
            content: "Unable to query meal! Try again after a few minutes."));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var width = MediaQuery.of(context).size.width - 50;
    var isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    var today = DateTime.now();
    var month = DateFormat("MMM").format(today);
    var day = DateFormat(DateFormat.ABBR_WEEKDAY).format(today);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Column(children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 25),
            child: Row(
              children: [
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: ProfilePicture(firstName: appState.firstName),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      "${appState.firstName} ${appState.lastName}",
                      colors: [
                        Colors.orange[800]!,
                        Colors.orange,
                        isDarkMode
                            ? const Color.fromARGB(175, 255, 255, 255)
                            : const Color.fromARGB(175, 0, 0, 0)
                      ],
                      gradientDirection: GradientDirection.ltr,
                      gradientType: GradientType.linear,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text('$day, ${today.day} $month',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 90, 88, 88))),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.white.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
          child: Column(
            children: [
              SizedBox(
                  height: 100,
                  width: 100,
                  child: ProfilePicture(firstName: appState.firstName)),
              Text(
                "${appState.firstName} ${appState.lastName}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("/medications");
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(42, 14, 14, 14),
                            blurRadius: 3,
                            offset: Offset(0, 2)),
                      ]),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medication,
                        color: Colors.orange,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Medications",
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: const Color.fromRGBO(91, 88, 77, 1)),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("/history");
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(42, 14, 14, 14),
                            blurRadius: 3,
                            offset: Offset(0, 2)),
                      ]),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.history_outlined,
                        color: Colors.orange,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "History",
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: const Color.fromRGBO(91, 88, 77, 1)),
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  "GlycoSafe V1.00",
                  style: GoogleFonts.inter(
                      color: const Color.fromRGBO(172, 170, 144, 1),
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.chevron_left_outlined),
                              onPressed: previousDay,
                              color: Colors.white),
                          const SizedBox(),
                          InkWell(
                            onTap: _getDate,
                            child: Row(children: [
                              Text(
                                displayDate,
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(Icons.calendar_month_outlined,
                                  size: 20, color: Colors.white)
                            ]),
                          ),
                          const SizedBox(),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            color: Colors.white,
                            onPressed: _isButtonDisabled ? null : nextDay,
                          )
                        ])),
                !_emptyMeal
                    ? foodsBody(isDarkMode, width, mealData, appState)
                    : NoFoodsBody(width: width)
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget progress(double guideline, double amount) {
    var width = 100.0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.15),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          width: width,
          height: 8,
        ),
        Container(
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          constraints: const BoxConstraints(maxWidth: 100),
          width: (amount / guideline) * width,
          height: 8,
        )
      ]),
    );
  }

  Widget foodsBody(
      bool isDarkMode, double width, List mealData, MyAppState appstate) {
    var totalCalories = mealData[0]["total_calories"];
    var totalCarbs = mealData[0]["total_carbs"];
    var totalProtein = mealData[0]["total_proteins"];
    var totalFat = mealData[0]["total_fat"];
    var totalFibre = mealData[0]["total_fibre"];
    var foods = mealData[0]["foods"];
    print(mealData);
    print(foods);
    return Column(
      children: [
        calorieContainer(appstate, isDarkMode, totalCalories, totalCarbs,
            totalFat, totalFibre, totalProtein),
        const SizedBox(height: 20),
        macroNutrientContainer(
            totalCarbs, totalProtein, totalFat, totalFibre, appstate),
        const SizedBox(height: 10),
        MealCardWidget(
          isToday: _isToday,
          foods: foods,
          isDarkMode: isDarkMode,
          width: width,
        )
      ],
    );
  }

  Widget calorieContainer(MyAppState appstate, bool isDarkMode, double calories,
      double carbs, double fat, double fibre, double protein) {
    return Card(
      color: isDarkMode
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.1),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, top: 25, right: 16.0, bottom: 1),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularProgress(
                    color: Colors.orange,
                    width: 100,
                    nutrient: "kcal",
                    calories: calories,
                    progress: calories / 2000),
                // Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Carbohydrates',
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 12)),
                        progress(130, carbs)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Proteins',
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 12)),
                        progress(appstate.weight * 0.36 * 2.2, protein)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fibre',
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 12)),
                        progress(30, fibre)
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: _toggleMacros,
                child: Icon(
                  _showMacros
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  size: 45,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget macroNutrientContainer(double carbs, double protein, double fat,
      double fibre, MyAppState appstate) {
    return AnimatedOpacity(
        opacity: _showMacros ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Visibility(
          visible: _showMacros,
          child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white.withOpacity(0.1)),
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: macroNutrients("Carbs", carbs,
                            const Color.fromARGB(255, 231, 27, 27), 130),
                      ),
                      macroNutrients(
                          "Proteins",
                          protein,
                          const Color.fromARGB(255, 178, 27, 231),
                          appstate.weight * 0.36 * 2.2),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: macroNutrients("Fat", fat,
                            const Color.fromARGB(255, 27, 231, 182), 65),
                      ),
                      macroNutrients("Fibre", fibre,
                          const Color.fromARGB(255, 27, 170, 231), 30)
                    ]),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "*All nutritional goals are based on the recommended daily guideline of a normal person",
                  style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 122, 58, 58)),
                )
              ])),
        ));
  }

  Widget macroNutrients(
      String nutrient, double amount, Color color, double guideline) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        CircularProgress(
            color: color,
            width: (width * 0.8) / 5 - 5,
            nutrient: "g",
            calories: amount,
            progress: amount / guideline),
        const SizedBox(
          height: 18,
        ),
        Text(
          nutrient,
          style: GoogleFonts.openSans(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        )
      ],
    );
  }
}

class MealItem extends StatelessWidget {
  final String name;
  final double calories;

  const MealItem(this.name, this.calories, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.green.withOpacity(0.5)),
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(color: Colors.white)),
            Text('$calories', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
