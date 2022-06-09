//
//  Session.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import Foundation
import CoreMotion
import SwiftUI

// Contains past sessions, and any other data that we will need to save in the future
// Saved to UserDefaults so that when app gets reloaded, load data
class Model: ObservableObject {
    @Published var sessions: [Session] = []
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "SavedModel") {
            if let decoded = try? JSONDecoder().decode([Session].self, from: data) {
                sessions = decoded
                return
            }
        }

        sessions = []
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: "SavedModel")
        }
    }
    
    func addSession(session: Session) {
        sessions.append(session)
        save()
    }
}

// Keeps track of motion data and metadata for one recording
struct Session: Codable, Identifiable {
    var id = UUID()
    var motion: MotionData = MotionData()
    var airpodsMotion: MotionData = MotionData()
    
    var date: Date = Date()
    var type: String = "Session"
}

// Stores all motion data and timestamps for a recording
// Is there a cleaner way to do this..? Not sure
struct MotionData: Codable {
    var timestamps: [Int64] = []
    
    var quaternionX: [Double] = []
    var quaternionY: [Double] = []
    var quaternionZ: [Double] = []
    var quaternionW: [Double] = []
    
    var attitudePitch: [Double] = []
    var attitudeRoll: [Double] = []
    var attitudeYaw: [Double] = []
    
    var gravAccelX: [Double] = []
    var gravAccelY: [Double] = []
    var gravAccelZ: [Double] = []
    
    var accelX: [Double] = []
    var accelY: [Double] = []
    var accelZ: [Double] = []
    
    var rotationX: [Double] = []
    var rotationY: [Double] = []
    var rotationZ: [Double] = []
}


// Helper function for generating random data
func generateRandomSession() -> Session {
    let data = generateRandomMotionData()
    let airpodsData = generateRandomMotionData()
    
//    let year = 2022
//    let month = Int.random(in: 1...12)
//    let day = Int.random(in: 1...28)
    let date = Date(timeIntervalSinceNow: TimeInterval(CGFloat.random(in: -10000.0...10000)))
    
    let out = Session(motion: data, airpodsMotion: airpodsData, date: date, type: "Surgery")
    return out
}

func generateRandomMotionData() -> MotionData {
    let length = 100
    let minData = -5.0
    let maxData = 5.0
    
    var timestamps: [Int64] = []
    
    var quaternionX: [Double] = []
    var quaternionY: [Double] = []
    var quaternionZ: [Double] = []
    var quaternionW: [Double] = []
    
    var attitudePitch: [Double] = []
    var attitudeRoll: [Double] = []
    var attitudeYaw: [Double] = []
    
    var gravAccelX: [Double] = []
    var gravAccelY: [Double] = []
    var gravAccelZ: [Double] = []
    
    var accelX: [Double] = []
    var accelY: [Double] = []
    var accelZ: [Double] = []
    
    var rotationX: [Double] = []
    var rotationY: [Double] = []
    var rotationZ: [Double] = []
    
    for i in 0...length {
        timestamps.append(Int64(i))
        
        quaternionX.append(Double.random(in: minData..<maxData))
        quaternionY.append(Double.random(in: minData..<maxData))
        quaternionZ.append(Double.random(in: minData..<maxData))
        quaternionW.append(Double.random(in: minData..<maxData))
        
        attitudePitch.append(Double.random(in: minData..<maxData))
        attitudeRoll.append(Double.random(in: minData..<maxData))
        attitudeYaw.append(Double.random(in: minData..<maxData))
        
        gravAccelX.append(Double.random(in: minData..<maxData))
        gravAccelY.append(Double.random(in: minData..<maxData))
        gravAccelZ.append(Double.random(in: minData..<maxData))
        
        accelX.append(Double.random(in: minData..<maxData))
        accelY.append(Double.random(in: minData..<maxData))
        accelZ.append(Double.random(in: minData..<maxData))
        
        rotationX.append(Double.random(in: minData..<maxData))
        rotationY.append(Double.random(in: minData..<maxData))
        rotationZ.append(Double.random(in: minData..<maxData))
    }
    let data = MotionData(
        timestamps: timestamps,
        quaternionX:quaternionX,
        quaternionY:quaternionY,
        quaternionZ:quaternionZ,
        quaternionW:quaternionW,
        attitudePitch:attitudePitch,
        attitudeRoll:attitudeRoll,
        attitudeYaw:attitudeYaw,
        gravAccelX:gravAccelX,
        gravAccelY:gravAccelY,
        gravAccelZ:gravAccelZ,
        accelX:accelX,
        accelY:accelY,
        accelZ:accelZ,
        rotationX:rotationX,
        rotationY:rotationY,
        rotationZ:rotationZ
    )
    
    return data
}
