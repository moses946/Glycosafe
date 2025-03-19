import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/addedMealCard.dart';
import 'package:glycosafe_v1/components/emptymealcard.dart';

class MealCardWidget extends StatelessWidget {
  final List foods;
  final bool isDarkMode;
  final double width;
  final bool isToday;

  const MealCardWidget(
      {Key? key,
      required this.foods,
      required this.isDarkMode,
      required this.width,
      required this.isToday})
      : super(key: key);

  @override
  // Widget build(BuildContext context) {
  //   // Define the meal types
  //   List<String> mealTypes = ["B", "L", "D", "S"];
  //   List<Widget> mealCards = [];
  //   Map mealNames = {
  //     "B": "Breakfast",
  //     "L": "Lunch",
  //     "S": "Snack",
  //     "D": "Dinner"
  //   };

  //   if (foods.isNotEmpty) {
  //     for (var mealType in mealTypes) {
  //       // Get all maps that contain the mealType key
  //       var mealMaps =
  //           foods.where((element) => element.containsKey(mealType)).toList();

  //       // Check if there are any maps with the mealType key
  //       if (mealMaps.isNotEmpty) {
  //         for (var mealMap in mealMaps) {
  //           print("mealMap : $mealMap");
  //           // Get the list of food descriptions
  //           var foodDescriptions = mealMap[mealType]!['food_description'];
  //           var totalCalories = mealMap[mealType]!["calorie_amount"];
  //           var totalCarbs = mealMap[mealType]!["carbs_amount"];
  //           var totalProtein = mealMap[mealType]!["proteins_amount"];
  //           var totalFibre = mealMap[mealType]!["fat_amount"];
  //           var totalFat = mealMap[mealType]!["fibre_amount"];
  //           var imageUrl = mealMap[mealType]!["meal_url"];
  //           var allStats = [
  //             totalCalories,
  //             totalCarbs,
  //             totalProtein,
  //             totalFat,
  //             totalFibre
  //           ];
  //           print(foodDescriptions);

  //           mealCards.add(
  //             AddedMealCard(
  //               context: context,
  //               isDarkMode: isDarkMode,
  //               width: width,
  //               mealName: mealNames[mealType],
  //               foodDescription: foodDescriptions,
  //               allStats: allStats,
  //               imageUrl: imageUrl,
  //             ),
  //           );
  //           mealCards.add(const SizedBox(height: 10));
  //         }
  //       } else {
  //         mealCards.add(
  //           EmptyMealCard(
  //             context: context,
  //             isDarkMode: isDarkMode,
  //             meal: mealNames[mealType],
  //           ),
  //         );
  //         mealCards.add(const SizedBox(height: 10));
  //       }
  //     }

  //     // Remove the last SizedBox
  //     if (mealCards.isNotEmpty) {
  //       mealCards.removeLast();
  //     }
  //   } else {
  //     // Handle case where foods list is empty if necessary
  //     print("No foods data available");
  //   }

  //   return Column(children: mealCards);
  // }

  Widget build(BuildContext context) {
    // Define the meal types
    List<String> mealTypes = ["B", "L", "D", "S"];
    List<Widget> mealCards = [];
    List meals = [];
    Map mealNames = {
      "B": "Breakfast",
      "L": "Lunch",
      "S": "Snack",
      "D": "Dinner"
    };
    print(foods);
    if (foods.isNotEmpty) {
      for (var food in foods) {
        print(food);
        for (var mealType in mealTypes) {
          if (food.containsKey(mealType)) {
            meals.add(mealType);
            print(meals);
            var foodDescriptions = food[mealType]!['food_description'];
            var totalCalories = food[mealType]!["calorie_amount"];
            var totalCarbs = food[mealType]!["carbs_amount"];
            var totalProtein = food[mealType]!["proteins_amount"];
            var totalFibre = food[mealType]!["fat_amount"];
            var totalFat = food[mealType]!["fibre_amount"];
            var imageUrl = food[mealType]!["meal_url"];
            var allStats = [
              totalCalories,
              totalCarbs,
              totalProtein,
              totalFat,
              totalFibre
            ];
            print(foodDescriptions);

            mealCards.add(
              AddedMealCard(
                context: context,
                isDarkMode: isDarkMode,
                width: width,
                mealName: mealNames[mealType],
                foodDescription: foodDescriptions,
                allStats: allStats,
                imageUrl: imageUrl,
              ),
            );
            mealCards.add(const SizedBox(height: 10));

            break;
          }
        }
      }
      if (isToday) {
        for (var mealType in mealTypes) {
          if (!meals.contains(mealType)) {
            mealCards.add(
              EmptyMealCard(
                  context: context,
                  isDarkMode: isDarkMode,
                  meal: mealNames[mealType]),
            );
            mealCards.add(const SizedBox(height: 10));
          }
        }
      }
    } else {
      for (var mealType in mealTypes) {
        mealCards.add(
          EmptyMealCard(
              context: context,
              isDarkMode: isDarkMode,
              meal: mealNames[mealType]),
        );
        mealCards.add(const SizedBox(height: 10));
      }
    }

    // for (var mealType in mealTypes) {
    //   // Find the map that contains the mealType key
    //   var mealMap = foods.firstWhere(
    //     (element) => element.containsKey(mealType),
    //     orElse: () => {},
    //   );

    //   // Check if the map has the mealType key
    //   if (mealMap.isNotEmpty) {
    //     print("mealMap : $mealMap");
    //     // Get the list of food descriptions
    //     var foodDescriptions = mealMap[mealType]!['food_description'];
    //     var totalCalories = mealMap[mealType]!["calorie_amount"];
    //     var totalCarbs = mealMap[mealType]!["carbs_amount"];
    //     var totalProtein = mealMap[mealType]!["proteins_amount"];
    //     var totalFibre = mealMap[mealType]!["fat_amount"];
    //     var totalFat = mealMap[mealType]!["fibre_amount"];
    //     var imageUrl = mealMap[mealType]!["meal_url"];
    //     var allStats = [
    //       totalCalories,
    //       totalCarbs,
    //       totalProtein,
    //       totalFat,
    //       totalFibre
    //     ];
    //     print(foodDescriptions);

    //     mealCards.add(
    //       AddedMealCard(
    //         context: context,
    //         isDarkMode: isDarkMode,
    //         width: width,
    //         mealName: mealNames[mealType],
    //         foodDescription: foodDescriptions,
    //         allStats: allStats,
    //         imageUrl: imageUrl,
    //       ),
    //     );
    //   } else {
    //     mealCards.add(
    //       EmptyMealCard(
    //           context: context,
    //           isDarkMode: isDarkMode,
    //           meal: mealNames[mealType]),
    //     );
    //   }

    //   mealCards.add(const SizedBox(height: 10));
    // }

    // Remove the last SizedBox
    if (mealCards.isNotEmpty) {
      mealCards.removeLast();
    }

    return Column(children: mealCards);
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
