//
//  NavigationView.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import SwiftUI

struct MainAppView: View {
    @EnvironmentObject private var detector: MotionDetector
    var body: some View {
        TabView {
            RecordSessionView()
                .tabItem {
                    VStack{
                        Image(systemName: "record.circle")
                        Text("Record Session")
                    }
                    
                }
//            MainSwiftUIView()
//                .environmentObject(detector)
                
            
            HistoryView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.xyaxis.line")
                        Text("Session History")
                    }
                    
                }
        }
    }
    
}

struct MainAppView_Previews: PreviewProvider {
    @StateObject static private var detector = MotionDetector(updateInterval: 0.01).started()

    static var previews: some View {
        MainAppView()
            .environmentObject(detector)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
