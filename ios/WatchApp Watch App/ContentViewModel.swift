//
//  ContentViewModel.swift
//  WatchApp Watch App
//
//  Created by Seongheon Park on 2022/06/10.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var meal: Meal?
    @Published var timeTable: TimeTable?
    
    init() {
        fetchItems()
    }
    
    func fetchItems() {
        let appGroup = UserDefaults.init(suiteName: "group.com.n30gu1.schoolman")
        
        if(appGroup != nil) {
            print("App Group isn't nil")
            do {
                let mealShared = appGroup?.string(forKey: "meal")
                if mealShared != nil {
                    let decoder = JSONDecoder()
                    meal = try decoder.decode(Meal.self, from: mealShared!.data(using: .utf8)!)
                }
                let timeTableShared = appGroup?.string(forKey: "meal")
                if timeTableShared != nil {
                    let decoder = JSONDecoder()
                    timeTable = try decoder.decode(TimeTable.self, from: timeTableShared!.data(using: .utf8)!)
                }
            } catch {
                print(error)
            }
        }
    }
}
