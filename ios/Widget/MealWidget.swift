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
        MealEntry(meal: Meal(meal: [], origin: [], calories: 0.0, nutrition: [:], mealType: 1, date: ""), date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MealEntry) -> ()) {
        let entry = MealEntry(meal: Meal(meal: [], origin: [], calories: 0.0, nutrition: [:], mealType: 1, date: ""), date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MealEntry>) -> ()) {
        var entries: [MealEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let appGroup = UserDefaults.init(suiteName: "group.com.n30gu1.schoolman")
        
        var mealData: Meal?
        
        if(appGroup != nil) {
            print("App Group isn't nil")
            do {
                let shared = appGroup?.string(forKey: "meal")
                if shared != nil {
                    let decoder = JSONDecoder()
                    mealData = try decoder.decode(Meal.self, from: shared!.data(using: .utf8)!)
                }
            } catch {
                print(error)
            }
        }
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MealEntry(meal: mealData, date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MealEntry: TimelineEntry {
    let meal: Meal?
    let date: Date
}

struct MealWidgetEntryView : View {
    var entry: MealTimelineProvider.Entry
    
    var body: some View {
        if let meal = entry.meal {
            ForEach(meal.meal, id: \.self) { menu in
                Text("\(menu)")
            }
        } else {
            Text(entry.date, style: .time)
        }
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
