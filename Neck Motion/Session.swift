//
//  Session.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import Foundation
import CoreMotion
import SwiftUI

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

struct Session: Codable, Identifiable {
    var id = UUID()
    var motion: MotionData = MotionData()
//    var phoneMotion: [MotionPoint]
    var date: Date = Date()
    var type: String = "Session"
}

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

func generateRandomSession() -> Session {
    let length = 100
    
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
        
        quaternionX.append(Double.random(in: -5.0..<5.0))
        quaternionY.append(Double.random(in: -5.0..<5.0))
        quaternionZ.append(Double.random(in: -5.0..<5.0))
        quaternionW.append(Double.random(in: -5.0..<5.0))
        
        attitudePitch.append(Double.random(in: -5.0..<5.0))
        attitudeRoll.append(Double.random(in: -5.0..<5.0))
        attitudeYaw.append(Double.random(in: -5.0..<5.0))
        
        gravAccelX.append(Double.random(in: -5.0..<5.0))
        gravAccelY.append(Double.random(in: -5.0..<5.0))
        gravAccelZ.append(Double.random(in: -5.0..<5.0))
        
        accelX.append(Double.random(in: -5.0..<5.0))
        accelY.append(Double.random(in: -5.0..<5.0))
        accelZ.append(Double.random(in: -5.0..<5.0))
        
        rotationX.append(Double.random(in: -5.0..<5.0))
        rotationY.append(Double.random(in: -5.0..<5.0))
        rotationZ.append(Double.random(in: -5.0..<5.0))
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
//    let year = 2022
//    let month = Int.random(in: 1...12)
//    let day = Int.random(in: 1...28)
    let date = Date(timeIntervalSinceNow: TimeInterval(CGFloat.random(in: -10000.0...10000)))
    
    let out = Session(motion: data, date: date, type: "Surgery")
    return out
}
