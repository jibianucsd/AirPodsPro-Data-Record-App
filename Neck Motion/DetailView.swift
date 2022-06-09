//
//  DetailView.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import SwiftUI
import SwiftUICharts

struct DetailView: View {
    let session: Session
    let sampleSize = 50
    let writer = CSVWriter()
    
    var body: some View {
            VStack {
                // Display Session Information
                HStack{
                    Text(session.date as Date, style: .date)
                        .font(.headline)
                    Text(session.date as Date, style: .time)
                        .font(.subheadline)
                    Spacer()
                    
                    ZStack {
                        Image(systemName: "airpodspro")
                            .font(.callout)
                        Image(systemName: "circle.slash")
                            .font(.title)
                            .foregroundColor(.red)
                            .opacity(session.airpodsMotion.timestamps.count > 0 ? 0 : 1)
                    }
                }
                HStack {
                    
                    Text(session.type)
                        .font(.title)
                    Spacer()
                }
                // Display Session Data
                ScrollView {
                    VStack {
                        LineChartView(data: sample(list: session.motion.attitudePitch, n: sampleSize), title: "Pitch", form: ChartForm.large, dropShadow: false)
                        LineChartView(data: sample(list: session.motion.attitudeRoll, n: sampleSize), title: "Roll", form: ChartForm.large, dropShadow: false)
                        LineChartView(data: sample(list: session.motion.accelZ, n: sampleSize), title: "Acceleration", form: ChartForm.large, dropShadow: false)
//                        PieChartView(data: [0.7, 0.2, 0.1], title: "Proportion of Good Posture")
                    }
                }
            }
            .toolbar {
                // Add share button for exporting CSV
                Button {
                    writeSession()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .padding()
    }
    
    func writeSession() {
        writer.writeSession(session: session)
    }
    
    // Sample data when displaying (otherwise graph super laggy)
    func sample(list: [Double], n: Int) -> [Double] {
        let interval = list.count / n
        var out: [Double] = []
        
        for i in 0..<n {
            out.append(list[i*interval])
        }
        return out
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(session: generateRandomSession())
    }
}
