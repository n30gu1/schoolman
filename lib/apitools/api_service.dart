import 'package:http/http.dart' as http;

class APIService {
  static APIService instance = APIService();

  final schoolInfoURI = Uri.parse(
      "https://open.neis.go.kr/hub/schoolInfo?KEY=0c78f44ac03648f49ce553a199fc0389&Type=json");
}
