import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';

class Recommendations extends StatelessWidget {
  const Recommendations(
      {super.key,
      required this.width,
      required this.foods,
      required this.recommendations,
      required this.rankings,
      required this.totalNutritionalFacts,
      required this.status});

  final double width;
  final List foods;
  final List recommendations;
  final Map rankings;
  final Map status;
  final Map totalNutritionalFacts;

  @override
  Widget build(BuildContext context) {
    var mealProvider = Provider.of<MealProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              // Top Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(156, 0, 0, 0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(110, 0, 0, 0),
                        spreadRadius: 2,
                        blurRadius: 2,
                        blurStyle: BlurStyle.normal,
                      )
                    ]),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Foods Identified",
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromRGBO(91, 88, 77, 1))),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i < foods.length; i++)
                            Text(
                              "${i + 1} . ${foods[i]}",
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ]),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        Text(
                          "Status: ",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.notoSerif(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey)),
                        ),
                        Row(
                          children: [
                            Text(
                              "Balanced: ",
                              style: GoogleFonts.notoSerif(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.white)),
                            ),
                            status["balanced"]
                                ? const Icon(
                                    Icons.recommend,
                                    color: Color.fromARGB(255, 3, 240, 50),
                                  )
                                : const Icon(
                                    Icons.dangerous_outlined,
                                    color: Color.fromARGB(255, 240, 3, 3),
                                  ),
                            const SizedBox(width: 50),
                            Text(
                              "Safe: ",
                              style: GoogleFonts.notoSerif(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.white)),
                            ),
                            status["safe"]
                                ? const Icon(
                                    Icons.recommend,
                                    color: Color.fromARGB(255, 3, 240, 50),
                                  )
                                : const Icon(
                                    Icons.dangerous_outlined,
                                    color: Color.fromARGB(255, 240, 3, 3),
                                  ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Middle Composition Cards

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  totalNutritionalFactCard(
                      "Calories",
                      totalNutritionalFacts["total_calories"]
                          .toStringAsFixed(2),
                      "Cal"),
                  totalNutritionalFactCard(
                      "Glycemic Load",
                      totalNutritionalFacts["total_glycemic_load"]
                          .toStringAsFixed(2),
                      ""),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    totalNutritionalFactCard(
                        "Carbohydrates",
                        totalNutritionalFacts["total_carbs"].toStringAsFixed(2),
                        "G"),
                    totalNutritionalFactCard(
                        "Proteins",
                        totalNutritionalFacts["total_proteins"]
                            .toStringAsFixed(2),
                        "G"),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // Bottom Recommendation card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(156, 0, 0, 0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(131, 0, 0, 0),
                        spreadRadius: 2,
                        blurRadius: 2,
                        blurStyle: BlurStyle.normal,
                      )
                    ]),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Recommendations",
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromRGBO(91, 88, 77, 1))),
                      ),
                    ),
                    for (int i = 0; i < recommendations.length; i++)
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline_outlined,
                              color: Colors.green),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "${recommendations[i]}",
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                          barrierDismissible:
                              false, //prevent dismissing or device navigation
                          context: context,
                          builder: ((context) => AlertDialog.adaptive(
                                backgroundColor:
                                    const Color.fromARGB(255, 23, 23, 23),
                                title: Text(
                                  "Add meal to diary",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white.withOpacity(0.6)),
                                ),
                                content: const Text(
                                  "What meal was this?",
                                  style: TextStyle(
                                      color: Color.fromRGBO(91, 88, 77, 1),
                                      fontSize: 15),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        var imageUrl = await _logMeal(
                                            context, true, "breakfast");
                                        mealProvider.logMeal(
                                            imageUrl!,
                                            "B",
                                            rankings,
                                            foods,
                                            totalNutritionalFacts);

                                        Navigator.of(context)
                                            .pushReplacementNamed("/camera");
                                      },
                                      child: const Text("Breakfast",
                                          style:
                                              TextStyle(color: Colors.orange))),
                                  TextButton(
                                      onPressed: () async {
                                        var imageUrl = await _logMeal(
                                            context, true, "lunch");
                                        mealProvider.logMeal(
                                            imageUrl!,
                                            "L",
                                            rankings,
                                            foods,
                                            totalNutritionalFacts);

                                        Navigator.of(context)
                                            .pushReplacementNamed("/camera");
                                      },
                                      child: const Text("Lunch",
                                          style:
                                              TextStyle(color: Colors.orange))),
                                  TextButton(
                                      onPressed: () async {
                                        var imageUrl = await _logMeal(
                                            context, true, "dinner");
                                        mealProvider.logMeal(
                                            imageUrl!,
                                            "D",
                                            rankings,
                                            foods,
                                            totalNutritionalFacts);

                                        Navigator.of(context)
                                            .pushReplacementNamed("/camera");
                                      },
                                      child: const Text("Dinner",
                                          style:
                                              TextStyle(color: Colors.orange))),
                                  TextButton(
                                      onPressed: () async {
                                        var imageUrl = await _logMeal(
                                            context, true, "snack");
                                        mealProvider.logMeal(
                                            imageUrl!,
                                            "S",
                                            rankings,
                                            foods,
                                            totalNutritionalFacts);
                                        Navigator.of(context)
                                            .pushReplacementNamed("/camera");
                                      },
                                      child: const Text("Snack",
                                          style:
                                              TextStyle(color: Colors.orange))),
                                ],
                              )));
                    },
                    icon: const Icon(
                      Icons.bookmark_add,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 30,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _logMeal(context, false, "");

                      Navigator.of(context).pushReplacementNamed("/camera");
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget totalNutritionalFactCard(String title, String value, String nutrient) {
    return Container(
      padding: const EdgeInsets.all(10),
      // margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromARGB(183, 216, 240, 35)),
      width: (width / 2) - 20,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Color.fromARGB(255, 50, 50, 50),
                fontSize: 15,
                fontWeight: FontWeight.w900),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(Icons.fireplace),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "$value $nutrient",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blueGrey[800]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<String?> _logMeal(
      BuildContext context, bool option, String mealType) async {
    try {
      EasyLoading.show(
          status: option ? "Logging meal to diary" : "Discarding meal");
      var url = Endpoints().meal_confirm;
      var request = http.Request("POST", Uri.parse(url));
      var tokens = await TokenService().getTokens();
      var accessToken = Jwt.parseJwt(tokens[0]!);
      var userId = accessToken["user_id"];
      // request.headers["Authorization"] = "Bearer $accessToken";

      request.body =
          jsonEncode({"user_id": userId, "log": option, "meal_type": mealType});
      var streamedresponse = await request.send();
      var response = await http.Response.fromStream(streamedresponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("success");
        print(response.body);
        var message = jsonDecode(response.body)["meal_url"];
        print(message);
        EasyLoading.dismiss();
        return message;
      }
      EasyLoading.dismiss();
      return '';
    } on http.ClientException {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Check your internet connection and try again."));
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Unable to query meal! Try again after a few minutes."));
    }
    return null;
  }
}
