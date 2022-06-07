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
}

struct TimeTableItem: Codable {
    let period: Int
    let subject: String
}
