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
    
    
    @State var recording = false
    @State var sessionType: String = "Surgery"
    
    @State var session = Session(data: [], date: Date() as NSDate, type: nil)
    
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
                detector.onUpdate = {
                    displayData.append(-detector.pitch)
                    if displayData.count > maxData {
                        displayData = Array(displayData.dropFirst())
                    }
                    
                    session.data.append(-detector.pitch)
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
        session.data.removeAll()
    }

    func saveRecording() {
        
    }
}



struct RecordSessionView_Previews: PreviewProvider {
    @StateObject static private var detector = MotionDetector(updateInterval: 0.01)

    static var previews: some View {
        RecordSessionView()
            .environmentObject(detector)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
        
    }
}
