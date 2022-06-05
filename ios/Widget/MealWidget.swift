//
//  MealWidget.swift
//  Runner
//
//  Created by 박성헌 on 2022/05/14.
//

import WidgetKit
import SwiftUI

struct MealTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> MealEntry {
        MealEntry(meal: Meal(meal: [], origin: [], calories: 0.0, nutrition: [:], mealType: 1, date: Date()), date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (MealEntry) -> ()) {
        let entry = MealEntry(meal: Meal(meal: [], origin: [], calories: 0.0, nutrition: [:], mealType: 1, date: Date()), date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MealEntry>) -> ()) {
        var entries: [MealEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let appGroup = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: 'group.com.n30gu1.schoolman')
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MealEntry(meal: Meal(meal: [], origin: [], calories: 0.0, nutrition: [:], mealType: 1, date: Date()), date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MealEntry: TimelineEntry {
    let meal: Meal
    let date: Date
}

struct MealWidgetEntryView : View {
    var entry: MealTimelineProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct MealWidget: Widget {
    let kind: String = "MealWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MealTimelineProvider()) { entry in
            MealWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Meal Widget")
        .description("Under Construction. Do not leak.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
