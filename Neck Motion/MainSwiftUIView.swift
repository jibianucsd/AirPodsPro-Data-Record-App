//
//  MainSwiftUIView.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/11/22.
//

import SwiftUI
import CoreMotion
import SwiftUICharts

struct MainSwiftUIView: View {
    @EnvironmentObject private var detector: MotionDetector
    let writer = CSVWriter()
    let f = DateFormatter()
    var write: Bool = false
    
    let graphMaxValueMostSensitive = 0.01
    let graphMaxValueLeastSensitive = 1.0
    let sensitivity = 0.5
    let maxData = 1000
    
    @State private var data = [Double]()
    
    var graphMaxValue: Double {
        graphMaxValueMostSensitive + (1 - sensitivity) * (graphMaxValueLeastSensitive - graphMaxValueMostSensitive)
    }

    var graphMinValue: Double {
        -graphMaxValue
    }
    
    var body: some View {
        ZStack {

            VStack {
                Spacer()
                Text("Neck Motion Detector")
                    .font(.title)
                
                Spacer()
//                LineGraph(data: data, maxData: maxData, minValue: graphMinValue, maxValue: graphMaxValue)
//                    .clipped()
//                    .background(Color.accentColor.opacity(0.1))
//                    .cornerRadius(20)
//                    .padding()
//                    .aspectRatio(1, contentMode: .fit)
                LineView(data: data, title: "Title", legend: "Legendary")
                    .padding()
                Spacer()
                HStack {
                    Button {
                        
                    } label: {
                        Text("Record")
                    }.padding()
                    
                    Button {
                        
                    } label: {
                        Text("Save")
                    }.padding()

                }
                Spacer()
            }
        }
        .onAppear {
            detector.onUpdate = {
                data.append(-detector.pitch)
                if data.count > maxData {
                    data = Array(data.dropFirst())
                }
            }
        }

        
    }
}

struct MainSwiftUIView_Previews: PreviewProvider {
    @StateObject static private var detector = MotionDetector(updateInterval: 0.01).started()

    static var previews: some View {
        MainSwiftUIView()
            .environmentObject(detector)
    }
}
