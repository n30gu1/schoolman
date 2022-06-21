//
//  ContentViewModel.swift
//  WatchApp Watch App
//
//  Created by Seongheon Park on 2022/06/10.
//

import Foundation
import Combine
import WatchConnectivity

class ContentViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var meal: Meal?
    @Published var timeTable: TimeTable?
    @Published var loadingState: LoadingState = .loading
    
    private let session: WCSession
    let api = APIService.instance
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
        
        loadFromUserDefaults()
    }
    
    func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        guard let schoolCode = defaults.string(forKey: "schoolCode") else { return }
        guard let regionCode = defaults.string(forKey: "regionCode") else { return }
        guard let schoolType = defaults.string(forKey: "schoolType") else { return }
        guard let grade = defaults.string(forKey: "grade") else { return }
        guard let className = defaults.string(forKey: "className") else { return }
        
        api.schoolCode = schoolCode
        api.regionCode = regionCode
        api.schoolType = schoolType
        api.grade = grade
        api.className = className
        
        // TODO: Implement Fetching By Time
        Task(priority: .high) {
            let mealType = autoMealType()
            self.meal = try! await api.fetchMeal(date: Date(), mealType: mealType)
            self.timeTable = try! await api.fetchTimeTable(date: Date())
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
        api.schoolCode = (message["schoolCode"] as! String)
        api.regionCode = (message["regionCode"] as! String)
        api.schoolType = (message["schoolType"] as! String)
        api.grade = (message["grade"] as! String)
        api.className = (message["class"] as! String)
        
        let defaults = UserDefaults.standard
        
        defaults.set(api.schoolCode, forKey: "schoolCode")
        defaults.set(api.regionCode, forKey: "regionCode")
        defaults.set(api.schoolType, forKey: "schoolType")
        defaults.set(api.grade, forKey: "grade")
        defaults.set(api.className, forKey: "className")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Current Activation State: \(activationState)")
    }
}

enum LoadingState {
    case loading
    case failed
    case succeeded
}
