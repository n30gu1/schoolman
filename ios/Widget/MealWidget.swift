//
//  MealWidget.swift
//  Runner
//
//  Created by 박성헌 on 2022/05/14.
//

import WidgetKit
import SwiftUI

class MealGetter: ObservableObject {
    var meal: Meal?
    var isLoaded = false
    var date = Date()
    
    init(_ date: Date) {
        self.date = date
        Task {
            do {
                isLoaded = false
                let mealType: MealType = {
                    let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
                    let breakfast = Calendar.current.date(bySettingHour: 7, minute: 00, second: 00, of: Date())!
                    let lunch = Calendar.current.date(bySettingHour: 13, minute: 00, second: 00, of: Date())!
                    let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
                    
                    switch self.date {
                    case zero...breakfast:
                        return MealType.breakfast
                    case breakfast...lunch:
                        return MealType.lunch
                    case lunch...dinner:
                        return MealType.dinner
                    default:
                        return MealType.nextDayBreakfast
                    }
                }()
                meal = try await APIService.instance.fetchMeal(date: self.date, mealType: mealType)
                isLoaded = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct MealTimelineProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> MealEntry {
        MealEntry(meal: Meal(meal: [], origin: [], calories: 0.0, nutrition: [:], mealType: MealType.breakfast), date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MealEntry) -> ()) {
        let entry = MealEntry(meal: Meal(meal: [], origin: [], calories: 0.0, nutrition: [:], mealType: MealType.breakfast), date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MealEntry>) -> ()) {
        var entries: [MealEntry] = []
        
        let currentDate = Date()
        APIService.instance.setAppGroup()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            let getter = MealGetter(entryDate)
            while getter.isLoaded == false {}
            let entry = MealEntry(meal: getter.meal!, date: entryDate)
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
