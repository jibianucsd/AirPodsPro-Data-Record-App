//
//  RecordSessionView.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import SwiftUI
import SwiftUICharts

struct RecordSessionView: View {
    @EnvironmentObject private var detector: MotionDetector
    @EnvironmentObject private var airpodsDetector: AirpodsMotionDetector

    @EnvironmentObject var model: Model
    
    @State var recording = false
    @State var airpodsAvailable = false
    @State var sessionType: String = "Surgery"
    
    @State var session = Session(motion: MotionData(), airpodsMotion: MotionData(), date: Date(), type: "Surgery")
    // @State for live graph updates
    
    @State private var displayData = [Double]()
    let maxData = 800
    
    var body: some View {
        NavigationView {
            VStack {
                // Display header data, session type text feild
                VStack {
                    HStack{
                        Text(Date(), style: .date)
                            .font(.headline)
                        Spacer()
                        Button(action: resetAirpodsAvailableStatus) {
                            Image(systemName: "arrow.clockwise")
                                .font(.callout)
                        }
                        ZStack {
                            Image(systemName: "airpodspro")
                                .font(.callout)
                            Image(systemName: "circle.slash")
                                .font(.title)
                                .foregroundColor(.red)
                                .opacity(airpodsAvailable ? 0 : 1)
                        }
                    }
                    HStack {
                        if #available(iOS 15.0, *) {
                            TextField("Session Type", text: $sessionType)
                                .font(.title)
                                .onSubmit {
                                    session.type = sessionType
                                }
                        } else {
                            TextField("Session Type", text: $sessionType)
                                .font(.title)
                        }
                        Spacer()
                    }

                    
                }
                .padding()
                
                VStack {
                    ZStack {
                        // Display Big play button, or Big chart
                        Button(action: startRecording) {
                            Image(systemName: "play.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(100)
                        }
                        .disabled(recording)
                        .opacity(recording ? 0 : 1)
                        
                        LineView(data: displayData, title: "Pitch")
                            .highPriorityGesture(DragGesture()
                                .onChanged({ value in
                                    // disable line view gesture?
                                }))
                            .padding()
                            .opacity(recording ? 1 : 0)

                    }
                    
                    // Display small buttons
                    HStack {
                        Button(action: pauseRecording) {
                            Image(systemName: "pause.circle")
                                .font(.title)
                                .padding()
                        }
                        Button(action: saveRecording) {
                            Image(systemName: "checkmark.circle")
                                .font(.title)
                                .padding()
                        }
                        Button(action: trashRecording) {
                            Image(systemName: "trash.circle")
                                .font(.title)
                                .padding()
                        }
                        
                    }
                    .disabled(!recording)
                }
                
            }
            .navigationTitle("New Session")
            .onAppear {
                // Run when view first loads
                
                resetAirpodsAvailableStatus()
                detector.start()
                airpodsDetector.start()
                
                // Update Session motion when we get updates from MotionDetector
                // This will update the LineChart because session is @State
                detector.onUpdate = { motion in
                    if recording {
                        if !airpodsAvailable {
                            displayData.append(motion.attitude.pitch)
                            if displayData.count > maxData {
                                displayData = Array(displayData.dropFirst())
                            }
                        }
                       
                        
                        session.motion.timestamps.append(Date().currentTimeMillis())
                        
                        session.motion.quaternionX.append(motion.attitude.quaternion.x)
                        session.motion.quaternionY.append(motion.attitude.quaternion.y)
                        session.motion.quaternionZ.append(motion.attitude.quaternion.z)
                        session.motion.quaternionW.append(motion.attitude.quaternion.w)
                        
                        session.motion.attitudePitch.append(motion.attitude.pitch)
                        session.motion.attitudeRoll.append(motion.attitude.roll)
                        session.motion.attitudeYaw.append(motion.attitude.yaw)
                        
                        session.motion.gravAccelX.append(motion.gravity.x)
                        session.motion.gravAccelY.append(motion.gravity.y)
                        session.motion.gravAccelZ.append(motion.gravity.z)
                        
                        session.motion.accelX.append(motion.userAcceleration.x)
                        session.motion.accelY.append(motion.userAcceleration.y)
                        session.motion.accelZ.append(motion.userAcceleration.z)
                        
                        session.motion.rotationX.append(motion.rotationRate.x)
                        session.motion.rotationY.append(motion.rotationRate.y)
                        session.motion.rotationZ.append(motion.rotationRate.z)
                    }
                }
                
                airpodsDetector.onUpdate = { motion in
                    airpodsAvailable = true
                    
                    if recording {
                        displayData.append(motion.attitude.pitch)
                        if displayData.count > maxData {
                            displayData = Array(displayData.dropFirst())
                        }
                        
                        session.airpodsMotion.timestamps.append(Date().currentTimeMillis())
                        
                        session.airpodsMotion.quaternionX.append(motion.attitude.quaternion.x)
                        session.airpodsMotion.quaternionY.append(motion.attitude.quaternion.y)
                        session.airpodsMotion.quaternionZ.append(motion.attitude.quaternion.z)
                        session.airpodsMotion.quaternionW.append(motion.attitude.quaternion.w)
                        
                        session.airpodsMotion.attitudePitch.append(motion.attitude.pitch)
                        session.airpodsMotion.attitudeRoll.append(motion.attitude.roll)
                        session.airpodsMotion.attitudeYaw.append(motion.attitude.yaw)
                        
                        session.airpodsMotion.gravAccelX.append(motion.gravity.x)
                        session.airpodsMotion.gravAccelY.append(motion.gravity.y)
                        session.airpodsMotion.gravAccelZ.append(motion.gravity.z)
                        
                        session.airpodsMotion.accelX.append(motion.userAcceleration.x)
                        session.airpodsMotion.accelY.append(motion.userAcceleration.y)
                        session.airpodsMotion.accelZ.append(motion.userAcceleration.z)
                        
                        session.airpodsMotion.rotationX.append(motion.rotationRate.x)
                        session.airpodsMotion.rotationY.append(motion.rotationRate.y)
                        session.airpodsMotion.rotationZ.append(motion.rotationRate.z)
                    }
                }
            }
            .onDisappear {
                if !recording {
                    detector.stop()
                    airpodsDetector.stop()
                }
            }
        }
    }
    
    func resetAirpodsAvailableStatus() {
//        withAnimation {
//            airpodsAvailable = airpodsDetector.motionManager.isDeviceMotionAvailable
//            print("Airpods available: ", airpodsAvailable)
//        }
        airpodsAvailable = false
    }
    
    func startRecording() {
        withAnimation {
            recording = true
            detector.start()
            airpodsDetector.start()
        }
    }

    func pauseRecording() {
        withAnimation {
            recording = false
//            detector.stop()
//            airpodsDetector.stop()
        }
    }

    func trashRecording() {
        withAnimation {
            recording = false
        }
//        detector.stop()
//        airpodsDetector.stop()
        displayData.removeAll()
        session.motion = MotionData()
        session.airpodsMotion = MotionData()
    }

    func saveRecording() {
        pauseRecording()
        model.addSession(session: session)
        // Save session to model, clear it
        session = Session()
        displayData.removeAll()
    }
}



struct RecordSessionView_Previews: PreviewProvider {
    @StateObject static private var detector = MotionDetector(updateInterval: 0.01)
    @StateObject static private var airpodsDetector = AirpodsMotionDetector(updateInterval: 0.01)

    @StateObject static var model = Model()
    
    static var previews: some View {
        RecordSessionView()
            .environmentObject(detector)
            .environmentObject(airpodsDetector)
            .environmentObject({ () -> Model in
                            let model = Model()
                
                            let session1 = generateRandomSession()
                            let session2 = generateRandomSession()
                            model.sessions.append(session1)
                            model.sessions.append(session2)
                
                            return model
                        }() )
        
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
        
    }
}
