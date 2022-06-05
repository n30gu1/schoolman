//
//  TimeTableWidget.swift
//  Runner
//
//  Created by 박성헌 on 2022/05/14.
//

import WidgetKit
import SwiftUI

struct TimeTableTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimeTableEntry {
        TimeTableEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (TimeTableEntry) -> ()) {
        let entry = TimeTableEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TimeTableEntry>) -> ()) {
        var entries: [TimeTableEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let appGroup = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: 'group.com.n30gu1.schoolman')
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = TimeTableEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TimeTableEntry: TimelineEntry {
    let date: Date
}

struct TimeTableWidgetEntryView : View {
    var entry: MealTimelineProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct TimeTableWidget: Widget {
    let kind: String = "TimeTableWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MealTimelineProvider()) { entry in
            MealWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Time Table Widget")
        .description("Under Construction. Do not leak.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
