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
    
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func send(message: [String:Any]) {
        session.sendMessage(message, replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Current Activation State: \(activationState)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }
}
