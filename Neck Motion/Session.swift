//
//  Session.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import Foundation
import CoreMotion

struct Session: Codable {
    var motion: MotionData
//    var phoneMotion: [MotionPoint]
    let date: Date
    var type: String
}

struct MotionData: Codable {
    var timestamps: [Int64]
    var pitch: [Double]
    var roll: [Double]
    var yaw: [Double]
}

func generateRandomSession() {
    
}
