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
    @EnvironmentObject var model: Model
    
    @State var recording = false
    @State var sessionType: String = "Surgery"
    
    @State var session = Session(motion: MotionData(), date: Date(), type: "Surgery")
    
    @State private var displayData = [Double]()
    let maxData = 800
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack{
                        Text(Date(), style: .date)
                            .font(.headline)
                        Spacer()
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
                    
                                    
                    HStack {
                        Button(action: pauseRecording) {
                            Image(systemName: "pause.circle")
                                .font(.title)
                                .padding()
                        }
                        Button(action: saveRecording) {
                            Image(systemName: "doc.circle")
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
                detector.onUpdate = { motion in
                    displayData.append(-detector.pitch)
                    if displayData.count > maxData {
                        displayData = Array(displayData.dropFirst())
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
        }
    }
    
    func startRecording() {
        withAnimation {
            recording = true
            detector.start()
        }
    }

    func pauseRecording() {
        withAnimation {
            recording = false
            detector.stop()
        }
    }

    func trashRecording() {
        withAnimation {
            recording = false
        }
        detector.stop()
        displayData.removeAll()
        session.motion = MotionData()
    }

    func saveRecording() {
        pauseRecording()
        model.addSession(session: session)
        session = Session()
        displayData.removeAll()
    }
}



struct RecordSessionView_Previews: PreviewProvider {
    @StateObject static private var detector = MotionDetector(updateInterval: 0.01)
    @StateObject static var model = Model()
    
    static var previews: some View {
        RecordSessionView()
            .environmentObject(detector)
        
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
