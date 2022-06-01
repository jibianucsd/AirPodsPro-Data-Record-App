//
//  Session.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import Foundation
import CoreMotion
import SwiftUI

class Model: Codable, ObservableObject {
    var sessions: [Session] = []
}

struct Session: Codable, Identifiable {
    let id = UUID()
    var motion: MotionData = MotionData()
//    var phoneMotion: [MotionPoint]
    var date: Date = Date()
    var type: String = "Session"
}

struct MotionData: Codable {
    var timestamps: [Int64] = []
    var pitch: [Double] = []
    var roll: [Double] = []
    var yaw: [Double] = []
}

func generateRandomSession() -> Session {
    let length = 100
    var timestamps: [Int64] = []
    var pitch: [Double] = []
    var roll: [Double] = []
    var yaw: [Double] = []
    
    for i in 0...length {
        timestamps.append(Int64(i))
        pitch.append(Double.random(in: -5.0..<5.0))
        roll.append(Double.random(in: -5.0..<5.0))
        yaw.append(Double.random(in: -5.0..<5.0))
    }
    var data = MotionData(
        timestamps: timestamps,
        pitch: pitch,
        roll: roll,
        yaw: yaw
    )
//    let year = 2022
//    let month = Int.random(in: 1...12)
//    let day = Int.random(in: 1...28)
    let date = Date(timeIntervalSinceNow: TimeInterval(CGFloat.random(in: -10000.0...10000)))
    
    var out = Session(motion: data, date: date, type: "Surgery")
    return out
}
