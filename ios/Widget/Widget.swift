//
//  Widget.swift
//  Widget
//
//  Created by 박성헌 on 2022/05/14.
//

import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MealWidget()
        TimeTableWidget()
    }
}


struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        MealWidgetEntryView(entry:
                                MealEntry(meal: Meal(meal: [], origin: [], calories: 0.0, nutrition: [:], mealType: 1, date: Date()), date: Date())
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
