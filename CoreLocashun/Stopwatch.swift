//
//  Stopwatch.swift
//  StandApp
//
//  Created by Serafín Ennes Moscoso on 28/04/2021.
//

import SwiftUI

struct Stopwatch: View {

    /// Current progress time expresed in seconds
    @State private var progressTime = 0
    @State private var isRunning = false

    /// Computed properties to get the progressTime in hh:mm:ss format
    var hours: Int {
        progressTime / 3600
    }

    var minutes: Int {
        (progressTime % 3600) / 60
    }

    var seconds: Int {
        progressTime % 60
    }

    /// Increase progressTime each second
    @State private var timer: Timer?

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                StopwatchUnit(timeUnit: hours, timeUnitText: "HR", color: .black)
                Text(":")
                    .font(.system(size: 48))
                    .offset(y: -18)
                StopwatchUnit(timeUnit: minutes, timeUnitText: "MIN", color: .black)
                Text(":")
                    .font(.system(size: 48))
                    .offset(y: -18)
                StopwatchUnit(timeUnit: seconds, timeUnitText: "SEC", color: .black)
            }

            
        }
    }
}


struct StopwatchUnit: View {

    var timeUnit: Int
    var timeUnitText: String
    var color: Color

    /// Time unit expressed as String.
    /// - Includes "0" as prefix if this is less than 10.
    var timeUnitStr: String {
        let timeUnitStr = String(timeUnit)
        return timeUnit < 10 ? "0" + timeUnitStr : timeUnitStr
    }

    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: 2) {
                    Text(timeUnitStr.substring(index: 0))
                        .font(.system(size: 48))
                        .frame(width: 28)
                    Text(timeUnitStr.substring(index: 1))
                        .font(.system(size: 48))
                        .frame(width: 28)
                }
            }
            Text(timeUnitText)
                .font(.system(size: 16))
        }
    }
}

//struct Stopwatch_Previews: PreviewProvider {
//    static var previews: some View {
//        Stopwatch()
//    }
//}

extension String {
    func substring(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}
