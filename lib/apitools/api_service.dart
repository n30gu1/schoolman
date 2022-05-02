import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:schoolman/controller/global_controller.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/timetable.dart';
import 'package:schoolman/model/user.dart';

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

  Future<TimeTable> fetchTimeTable(School school) async {
    String today = DateFormat("yyyyMMdd").format(DateTime.now());
    User user = GlobalController.instance.user!;
    String? uriString;
    String? rootTitle;

    TimeTable? result;

    switch (school.schoolType) {
      case SchoolType.high:
        uriString =
            "https://open.neis.go.kr/hub/hisTimetable?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&ALL_TI_YMD=$today&GRADE=${user.grade}&CLASS_NM=${user.className}";
        print(uriString);
        rootTitle = "hisTimetable";
        break;
      case SchoolType.middle:
        uriString =
            "https://open.neis.go.kr/hub/misTimetable?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&ALL_TI_YMD=$today&GRADE=${user.grade}&CLASS_NM=${user.className}";
        print(uriString);
        rootTitle = "misTimetable";
        break;
      case SchoolType.elementary:
        uriString =
            "https://open.neis.go.kr/hub/elsTimetable?KEY=$_KEY&Type=json&ATPT_OFCDC_SC_CODE=${school.regionCode}&SD_SCHUL_CODE=${school.schoolCode}&ALL_TI_YMD=$today&GRADE=${user.grade}&CLASS_NM=${user.className}";
        print(uriString);
        rootTitle = "elsTimetable";
        break;
      case SchoolType.other:
        throw "Invalid School Type";
    }

    Uri uri = Uri.parse(uriString);
    result = await http.get(uri).then((response) {
      Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded["RESULT"] != null) {
        throw "Today is not a school day.";
      } else {
        return TimeTable.fromList(decoded[rootTitle][1]["row"]);
      }
    });

    return result!;
  }
}
