import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/date_converter.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/timetable.dart';
import 'package:schoolman/model/user.dart';

import '../model/schedule.dart';

class APIService {
  static APIService instance = APIService();

  static const _KEY = "0c78f44ac03648f49ce553a199fc0389";

  Future<List<dynamic>> fetchSchoolList() async {
    const uriString =
        "https://open.neis.go.kr/hub/schoolInfo?KEY=$_KEY&Type=json&pSize=1000";
    log("Fetch Started");
    List<dynamic> list = [];
    int pageCount = 1;
    int pageCountEnd = 1;
    do {
      await http
          .get(Uri.parse(uriString + "&pIndex=$pageCount"))
          .then((response) {
        if (response.statusCode == 200) {
          Map decoded = jsonDecode(response.body);
          if (decoded["schoolInfo"][0]["head"][1]["RESULT"]["CODE"] ==
              "INFO-000") {
            log("Fetch Done with no error");
            list.addAll(decoded["schoolInfo"][1]["row"]);

            if (pageCount == 1) {
              pageCountEnd = (decoded["schoolInfo"][0]["head"][0]
                          ["list_total_count"] /
                      1000)
                  .ceil();
            }

            pageCount++;
          } else {
            throw decoded["schoolInfo"][0]["head"][1]["RESULT"]["MESSAGE"];
          }
        } else {
          throw response.statusCode;
        }
      });
    } while (pageCount <= pageCountEnd);

    list.sort(((a, b) => a["SCHUL_NM"].toString().compareTo(b["SCHUL_NM"])));
    return list;
  }

  Future<School> fetchSchoolInfo(String regionCode, String schoolCode) async {
    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/schoolInfo?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=$regionCode&SD_SCHUL_CODE=$schoolCode");

    return await http.get(uri).then((response) {
      if (response.statusCode == 200) {
        Map decoded = jsonDecode(response.body);
        if (decoded["schoolInfo"][0]["head"][1]["RESULT"]["CODE"] ==
            "INFO-000") {
          log("Fetch Done with no error");
          School result = School.fromMap(decoded["schoolInfo"][1]["row"][0]);
          return result;
        } else {
          throw decoded["schoolInfo"][0]["head"][1]["RESULT"]["MESSAGE"];
        }
      } else {
        throw response.statusCode;
      }
    });
  }

  Future<List<dynamic>> fetchClassInfo(
      String regionCode, String schoolCode) async {
    final uri = Uri.parse(
        "https://open.neis.go.kr/hub/classInfo?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=$regionCode&SD_SCHUL_CODE=$schoolCode&AY=${DateTime.now().year}");

    return await http.get(uri).then((response) {
      if (response.statusCode == 200) {
        Map decoded = jsonDecode(response.body);
        if (decoded["classInfo"] != null) {
          log("Fetch Done with no error");
          return decoded["classInfo"][1]["row"];
        } else {
          throw decoded["RESULT"]["MESSAGE"];
        }
      } else {
        throw response.statusCode;
      }
    });
  }

  Future<TimeTable> fetchTimeTable() async {
    String today = DateFormat("yyyyMMdd").format(DateTime.now());
    School school = GlobalController.instance.school!;
    User user = GlobalController.instance.user!;
    String? uriString;
    String? rootTitle;

    TimeTable? result;

    switch (school.schoolType) {
      case SchoolType.high:
        uriString =
            "https://open.neis.go.kr/hub/hisTimetable?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&ALL_TI_YMD=$today&GRADE=${user.grade}&CLASS_NM=${user.className}";
        rootTitle = "hisTimetable";
        break;
      case SchoolType.middle:
        uriString =
            "https://open.neis.go.kr/hub/misTimetable?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&ALL_TI_YMD=$today&GRADE=${user.grade}&CLASS_NM=${user.className}";
        rootTitle = "misTimetable";
        break;
      case SchoolType.elementary:
        uriString =
            "https://open.neis.go.kr/hub/elsTimetable?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&ALL_TI_YMD=$today&GRADE=${user.grade}&CLASS_NM=${user.className}";
        rootTitle = "elsTimetable";
        break;
      case SchoolType.other:
        throw "Invalid School Type";
    }

    Uri uri = Uri.parse(uriString);
    result = await http.get(uri).then((response) {
      Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded["RESULT"] == null) {
        return TimeTable.fromList(decoded[rootTitle][1]["row"]);
      } else {
        throw "Today is not a school day.";
      }
    });

    return result!;
  }

  Future<List<TimeTable>> fetchTimeTableByDuration(
      DateTime date) async {
    School school = GlobalController.instance.school!;
    User user = GlobalController.instance.user!;
    String? uriString;
    String? rootTitle;

    List<TimeTable> result = [];

    for (var dayOrg in date.listByWeekday()) {
      String day = DateFormat("yyyyMMdd").format(dayOrg);
      switch (school.schoolType) {
        case SchoolType.high:
          uriString =
          "https://open.neis.go.kr/hub/hisTimetable?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&ALL_TI_YMD=$day&GRADE=${user.grade}&CLASS_NM=${user.className}";
          rootTitle = "hisTimetable";
          break;
        case SchoolType.middle:
          uriString =
          "https://open.neis.go.kr/hub/misTimetable?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&ALL_TI_YMD=$day&GRADE=${user.grade}&CLASS_NM=${user.className}";
          rootTitle = "misTimetable";
          break;
        case SchoolType.elementary:
          uriString =
          "https://open.neis.go.kr/hub/elsTimetable?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&ALL_TI_YMD=$day&GRADE=${user.grade}&CLASS_NM=${user.className}";
          rootTitle = "elsTimetable";
          break;
        case SchoolType.other:
          throw "Invalid School Type";
      }

      Uri uri = Uri.parse(uriString);
      result.add(await http.get(uri).then((response) {
        Map<String, dynamic> decoded = jsonDecode(response.body);
        if (decoded["RESULT"] == null) {
          return TimeTable.fromList(decoded[rootTitle][1]["row"]);
        } else {
          throw "Today is not a school day.";
        }
      }));
    }
    return result;
  }

  Future<List<Meal>> fetchMeal(MealType type) async {
    School school = GlobalController.instance.school!;
    // SET MMEAL_SC_CODE TO MODIFY MEAL TYPE
    String? uriString;
    if (type == MealType.nextDayBreakfast || type == MealType.nextDayLunch) {
      String day =
          DateFormat("yyyyMMdd").format(DateTime.now().add(Duration(days: 1)));
      uriString =
          "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&MLSV_YMD=$day&MMEAL_SC_CODE=${type.code}";
    } else {
      String today = DateFormat("yyyyMMdd").format(DateTime.now());
      uriString =
          "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&MLSV_YMD=$today&MMEAL_SC_CODE=${type.code}";
    }

    return await http.get(Uri.parse(uriString)).then((response) {
      Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded["RESULT"] == null) {
        List<Meal> result = [];
        for (var item in decoded["mealServiceDietInfo"][1]["row"]) {
          result.add(Meal.fromMap(item));
        }
        return result;
      } else {
        throw "There is no meal info";
      }
    });
  }

  Future<List<Meal>> fetchMealByDuration(MealType type, DateTime date) async {
    School school = GlobalController.instance.school!;
    List<Meal> result = [];
    List<DateTime> dateList = date.listByWeekdayWithAutoListing();

    for (DateTime date in dateList) {
      String? uriString;
      if (type == MealType.nextDayBreakfast || type == MealType.nextDayLunch) {
        String day =
        DateFormat("yyyyMMdd").format(date.add(Duration(days: 1)));
        uriString =
        "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&MLSV_YMD=$day&MMEAL_SC_CODE=${type.code}";
      } else {
        String today = DateFormat("yyyyMMdd").format(date);
        uriString =
        "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&MLSV_YMD=$today&MMEAL_SC_CODE=${type.code}";
      }

      result.add(await http.get(Uri.parse(uriString)).then((response) {
        Map<String, dynamic> decoded = jsonDecode(response.body);
        if (decoded["RESULT"] == null) {
          return Meal.fromMap(decoded["mealServiceDietInfo"][1]["row"][0]);
        } else {
          throw "There is no meal info";
        }
      }));
    }

    return result;
  }

  Future<List<Schedule>> fetchSchedule(int itemCount) async {
    School school = GlobalController.instance.school!;
    String today = DateFormat("yyyyMMdd").format(DateTime.now());
    String uriString =
        "https://open.neis.go.kr/hub/SchoolSchedule?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&AA_FROM_YMD=$today&pSize=$itemCount";
    return await http.get(Uri.parse(uriString)).then((response) {
      Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded["RESULT"] == null) {
        List<Schedule> result = [];
        for (var item in decoded["SchoolSchedule"][1]["row"]) {
          result.add(Schedule.fromMap(item));
        }

        return result;
      } else {
        throw "There is no schedule";
      }
    });
  }
}
