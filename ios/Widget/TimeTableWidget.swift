//
//  TimeTableWidget.swift
//  Runner
//
//  Created by 박성헌 on 2022/05/14.
//

import WidgetKit
import SwiftUI

class TimeTableGetter: ObservableObject {
    var timeTable: TimeTable?
    var isLoaded = false
    var date = Date()
    
    init(_ date: Date) {
        self.date = date
        
        Task {
            do {
                isLoaded = false
                timeTable = try await APIService.instance.fetchTimeTable(date: self.date)
                isLoaded = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct TimeTableTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimeTableEntry {
        TimeTableEntry(date: Date(), timeTable: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (TimeTableEntry) -> ()) {
        let entry = TimeTableEntry(date: Date(), timeTable: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TimeTableEntry>) -> ()) {
        var entries: [TimeTableEntry] = []
        
        let currentDate = Date()
        APIService.instance.setAppGroup()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            let getter = TimeTableGetter(entryDate)
            while getter.isLoaded == false {}
            let entry = TimeTableEntry(date: entryDate, timeTable: getter.timeTable!)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TimeTableEntry: TimelineEntry {
    let date: Date
    let timeTable: TimeTable?
}

struct TimeTableWidgetEntryView : View {
    var entry: TimeTableTimelineProvider.Entry

    var body: some View {
        if let timeTable = entry.timeTable {
            ForEach(timeTable.items, id: \.subject) { item in
                Text("\(item.subject)")
            }
        } else {
            Text(entry.date, style: .time)
        }
    }
}

struct TimeTableWidget: Widget {
    let kind: String = "TimeTableWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TimeTableTimelineProvider()) { entry in
            TimeTableWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Time Table Widget")
        .description("Under Construction. Do not leak.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
