//
//  NavigationView.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import SwiftUI

struct MainAppView: View {
    @EnvironmentObject private var detector: MotionDetector
    
    @EnvironmentObject var model: Model
    // Model keeps track of data, use EnvironmentObject to easily pass it between views

    var body: some View {
        TabView {
            RecordSessionView()
                .tabItem {
                    VStack{
                        Image(systemName: "record.circle")
                        Text("Record Session")
                    }
                }
                .environmentObject(model)
//            MainSwiftUIView()
//                .environmentObject(detector)
                
            
            HistoryView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.xyaxis.line")
                        Text("Session History")
                    }
                }
                .environmentObject(model)
        }
    }
    
}

struct MainAppView_Previews: PreviewProvider {
    @StateObject static private var detector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        MainAppView()
            .environmentObject(detector)
            .environmentObject({ () -> Model in
                    // Fill model with example data
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
