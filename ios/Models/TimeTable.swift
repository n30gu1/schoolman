//
//  TimeTable.swift
//  Runner
//
//  Created by 박성헌 on 2022/05/14.
//

import Foundation

struct TimeTable: Codable {
    let date: Date
    let items: [TimeTableItem]
    
    static func fromList(_ list: [[String : Any]]) -> TimeTable {
        let items: [TimeTableItem] = {
            var temp = [TimeTableItem]()
            for item in list {
                temp.append(TimeTableItem(period: Int((item["PERIO"] as! String))!, subject: (item["ITRT_CNTNT"] as! String)))
            }
            
            return temp
        }()
        return TimeTable(date: Date(), items: items)
    }
}

struct TimeTableItem: Codable {
    let period: Int
    let subject: String
}
