import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import '../components/endpoints.dart';

class MealProvider extends ChangeNotifier {
  List<Map> mealData = [
    {
      "foods": [],
      "total_calories": 0.0,
      "total_carbs": 0.0,
      "total_proteins": 0.0,
      "total_fat": 0.0,
      "total_fibre": 0.0
    }
  ];

  Future<void> getTodayMeals() async {
    try {
      print("trying to get meals");
      var tokens = await TokenService().getTokens();
      var formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      var accessToken = tokens[0];
      var userId = Jwt.parseJwt(accessToken!)["user_id"].toString();
      var url = "${Endpoints().get_meals}$userId?date=$formattedDate";
      var request = http.Request("GET", Uri.parse(url));
      request.headers["Authorization"] = "Bearer $accessToken";

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var data = jsonDecode(response.body);
        print(data);

        if (data.containsKey("detail")) {
        } else {
          print("addin meal to mealData state");
          mealData[0]["total_calories"] = data["total_calories"];
          mealData[0]["total_carbs"] = data["total_carbs"];
          mealData[0]["total_proteins"] = data["total_proteins"];
          mealData[0]["total_fat"] = data["total_fat"];
          mealData[0]["total_fibre"] = data["total_fibre"];
          mealData[0]["foods"] = data["foods"];
          print(mealData[0]["foods"]);
          notifyListeners();
        }
      } else {}
    } catch (e) {
      print(e);
    }
  }

  void logMeal(String imageUrl, String mealType, Map rankings, List foods,
      Map totalNutritionalFacts) {
    print(totalNutritionalFacts);
    var newMeal = {
      mealType: {
        "meal_url": imageUrl,
        "food_description": [
          for (String food in foods)
            {
              "food_name": food,
              "calories": rankings[food]["calories"],
            }
        ],
        "calorie_amount": totalNutritionalFacts["total_calories"],
        "carbs_amount": totalNutritionalFacts["total_carbs"],
        "proteins_amount": totalNutritionalFacts["total_proteins"],
        "fat_amount": totalNutritionalFacts["total_fat"],
        "fibre_amount": totalNutritionalFacts["total_fibre"],
      }
    };
    mealData[0]["foods"].add(newMeal);
    mealData[0]["total_calories"] += totalNutritionalFacts["total_calories"];
    mealData[0]["total_carbs"] += totalNutritionalFacts["total_carbs"];
    mealData[0]["total_proteins"] += totalNutritionalFacts["total_proteins"];
    mealData[0]["total_fat"] += totalNutritionalFacts["total_fat"];
    mealData[0]["total_fibre"] += totalNutritionalFacts["total_fibre"];
    notifyListeners();
  }
}
