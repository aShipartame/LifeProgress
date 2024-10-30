//
//  ContentView.swift
//  LifeProgress Watch App
//
//  Created by 阿诗诗瓦辛格 on 2024/10/29.
//

import SwiftUI

extension Color {
    init(hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

struct GlobalColors {
    static let year_color = Color(hex: 0x9CB898)
    static let month_color = Color(hex: 0xFFCDAA)
    static let day_color = Color(hex: 0xF14666)
}

struct CircularProgressView: View {
    var progress: Double
    var color: Color
    var diameter: CGFloat

    var body: some View {
        Circle()
            .trim(from: 0, to: CGFloat(progress))
            .stroke(color, lineWidth: 13)
            .rotationEffect(.degrees(-90))
            .frame(width: diameter, height: diameter)
    }
}

func yearProgress() -> Double {
    let currentDate = Date()
    let calendar = Calendar.current
    
    // Get the start and end of the year
    let year = calendar.component(.year, from: currentDate)
    let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
    let endOfYear = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))!
    
    // Calculate the total days in the year
    let totalDays = calendar.dateComponents([.day], from: startOfYear, to: endOfYear).day!
    let daysPassed = calendar.dateComponents([.day], from: startOfYear, to: currentDate).day!
    
    return Double(daysPassed) / Double(totalDays)
}

func monthProgress() -> Double {
    let currentDate = Date()
    let calendar = Calendar.current

    // Get the start and end of the month
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
    let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!

    // Calculate total days in the month
    let totalDaysInMonth = calendar.dateComponents([.day], from: startOfMonth, to: endOfMonth).day!
    let daysPassed = calendar.dateComponents([.day], from: startOfMonth, to: currentDate).day!

    return Double(daysPassed) / Double(totalDaysInMonth)
}

func dayProgress() -> Double {
    let currentDate = Date()
    let calendar = Calendar.current

    // Get the start and end of the day
    let startOfDay = calendar.startOfDay(for: currentDate)
    let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

    // Calculate total seconds in the day
    let totalSecondsInDay = endOfDay.timeIntervalSince(startOfDay)
    let secondsPassed = currentDate.timeIntervalSince(startOfDay)

    return secondsPassed / totalSecondsInDay
}

struct ContentView: View {
    @State private var yearProg: Double = 0.0
    @State private var monthProg: Double = 0.0
    @State private var dayProg: Double = 0.0

    var body: some View {
        VStack {
            Spacer() // Push the circles upward

            ZStack {
                CircularProgressView(progress: yearProg, color: GlobalColors.year_color, diameter: 120) // Year progress
                CircularProgressView(progress: monthProg, color: GlobalColors.month_color, diameter: 90) // Month progress
                CircularProgressView(progress: dayProg, color: GlobalColors.day_color, diameter: 60) // Day progress
            }
            .padding(.bottom, 10) // Add some space between circles and labels

//            HStack {
//                VStack(alignment: .trailing) {
//                    Text(String(format: "%.1f%%", yearProg * 100))
//                        .foregroundColor(GlobalColors.year_color)
//                    Text(String(format: "%.1f%%", monthProg * 100))
//                        .foregroundColor(GlobalColors.month_color)
//                    Text(String(format: "%.1f%%", dayProg * 100))
//                        .foregroundColor(GlobalColors.day_color)
//                }
//                VStack(alignment: .center) {
//                    Text("Y")
//                    Text("M")
//                    Text("D")
//                }
//                VStack(alignment: .trailing) {
//                    Text("passed")
//                    Text("passed")
//                    Text("passed")
//                }
//            }

            VStack(alignment: .center) {
                Text("The Progress of")
                HStack {
                    VStack(alignment: .center) {
                        Text("Year")
                            .foregroundColor(GlobalColors.year_color)
                        Text(String(format: "%.1f%%", yearProg * 100))
                            .foregroundColor(GlobalColors.year_color)
                    }
                    VStack(alignment: .center) {
                        Text("Month")
                            .foregroundColor(GlobalColors.month_color)
                        Text(String(format: "%.1f%%", monthProg * 100))
                            .foregroundColor(GlobalColors.month_color)
                    }
                    VStack(alignment: .center) {
                        Text("Day")
                            .foregroundColor(GlobalColors.day_color)
                        Text(String(format: "%.1f%%", dayProg * 100))
                            .foregroundColor(GlobalColors.day_color)
                    }
                }
            }

            Spacer() // Add more space below
        }
        .onAppear {
            self.updateProgress()
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                self.updateProgress()
            }
        }
        .padding()
        .navigationTitle("Progress Tracker")
    }

    private func updateProgress() {
        self.yearProg = yearProgress()
        self.monthProg = monthProgress()
        self.dayProg = dayProgress()
    }
}

#Preview {
    ContentView()
}
