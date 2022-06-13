//
//  APIService.swift
//  Runner
//
//  Created by Seongheon Park on 2022/06/11.
//

import Foundation

class APIService {
    static let instance = APIService(useAppGroup: false)
    private let KEY = "0c78f44ac03648f49ce553a199fc0389"
    
    var schoolCode: String?
    var regionCode: String?
    var schoolType: String?
    var grade: String?
    var className: String?
    
    init(useAppGroup: Bool) {
        if useAppGroup {
            let appGroup = UserDefaults.init(suiteName: "group.com.n30gu1.schoolman")
            if let group = appGroup {
                schoolCode = group.string(forKey: "schoolCode")
                regionCode = group.string(forKey: "regionCode")
                schoolType = group.string(forKey: "schoolType")
                grade = group.string(forKey: "grade")
                className = group.string(forKey: "class")
            }
        }
    }
    
    func fetchMeal(date: Date, mealType: MealType) async throws -> Void {
        guard let regionCode = self.regionCode else { throw NSError() }
        guard let schoolCode = self.schoolCode else { throw NSError() }
        let dateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyyMMdd"
            return f
        }()
        
        var uriString: String?
        
        if (mealType == .nextDatLunch || mealType == .nextDayBreakfast) {
            let day = date.addingTimeInterval(86400)
            uriString = "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=\(KEY)&Type=json&ATPT_OFCDC_SC_CODE=\(regionCode)&SD_SCHUL_CODE=\(schoolCode)&MLSV_YMD=\(dateFormatter.string(from: day))&MMEAL_SC_CODE=\(mealType.rawValue - 3)"
        } else {
            uriString = "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=\(KEY)&Type=json&ATPT_OFCDC_SC_CODE=\(regionCode)&SD_SCHUL_CODE=\(schoolCode)&MLSV_YMD=\(dateFormatter.string(from: date))&MMEAL_SC_CODE=\(mealType.rawValue)"
        }
        
        do {
            let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: URL(string: uriString!)!)
            
            let result = try! JSONSerialization.jsonObject(with: data) as? [String : [[String : [[String : Any]]]]]
            print(result?["mealServiceDietInfo"]?[1]["row"]?[0])
        } catch {
            throw error
        }
    }
    
    func fetchTimeTable(date: Date) async throws -> Void {
        
    }
}
