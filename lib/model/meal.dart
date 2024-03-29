import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:schoolman/date_converter.dart';

class Meal {
  List<String> meal;
  List<String> origin;
  double calories;
  Map<String, double> nutrition;
  MealType mealType;
  DateTime date;

  Meal(this.meal, this.origin, this.calories, this.nutrition, this.mealType, this.date);

  static fromMap(Map map) {
    List<String> meal = map["DDISH_NM"].split("<br/>");
    List<String> origin = map["ORPLC_INFO"].split("<br/>");
    double calories = double.parse(map["CAL_INFO"].replaceAll(" Kcal", ""));
    Map<String, double> nutrition = () {
      Map<String, double> result = Map<String, double>();
      for (var item in map["NTR_INFO"].split("<br/>")) {
        List split = item.split(" : ");
        result.addAll( { split[0] : double.parse(split[1]) } );
      }
      return result;
    }();
    DateTime mealDate = map["MLSV_YMD"].toString().convertFromyyyyMMdd();
    MealType mealType = () {switch (map["MMEAL_SC_CODE"]) {
      case "1":
        if (mealDate.day == DateTime.now().day) {
          return MealType.breakfast;
        } else {
          return MealType.nextDayBreakfast;
        }
      case "2":
        if (mealDate.day == DateTime.now().day) {
          return MealType.lunch;
        } else {
          return MealType.nextDayLunch;
        }
      case "3":
        return MealType.dinner;
      default:
        throw "Error";
    }}();
    
    return Meal(
      meal,
      origin,
      calories,
      nutrition,
      mealType,
      mealDate
    );
  }

  String toJson() {
    Map<String, dynamic> map = {
      "meal": this.meal,
      "origin": this.origin,
      "calories": this.calories,
      "nutrition": this.nutrition,
      "mealType": this.mealType.code,
      "date": DateFormat("yyyy/MM/dd").format(this.date)
    };

    return jsonEncode(map);
  }
}

enum MealType {
  breakfast(1),
  lunch(2),
  dinner(3),
  nextDayBreakfast(1),
  nextDayLunch(2);

  const MealType(this.code);
  final num code;
}