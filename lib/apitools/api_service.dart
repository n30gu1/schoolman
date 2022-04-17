import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:schoolman/model/school.dart';

class APIService {
  static APIService instance = APIService();

  Future<List<dynamic>> fetchSchoolList() async {
    const uriString =
        "https://open.neis.go.kr/hub/schoolInfo?KEY=0c78f44ac03648f49ce553a199fc0389&Type=json&pSize=1000";
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
        "https://open.neis.go.kr/hub/schoolInfo?KEY=0c78f44ac03648f49ce553a199fc0389&Type=json&ATPT_OFCDC_SC_CODE=$regionCode&SD_SCHUL_CODE=$schoolCode");

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
        "https://open.neis.go.kr/hub/classInfo?KEY=0c78f44ac03648f49ce553a199fc0389&Type=json&ATPT_OFCDC_SC_CODE=$regionCode&SD_SCHUL_CODE=$schoolCode&AY=${DateTime.now().year}");

    return await http.get(uri).then((response) {
      if (response.statusCode == 200) {
        Map decoded = jsonDecode(response.body);
        if (decoded["classInfo"][0]["head"][1]["RESULT"]["CODE"] ==
            "INFO-000") {
          log("Fetch Done with no error");
          return decoded["classInfo"][1]["row"];
        } else {
          throw decoded["classInfo"][0]["head"][1]["RESULT"]["MESSAGE"];
        }
      } else {
        throw response.statusCode;
      }
    });
  }
}
