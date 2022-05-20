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
    var body: some View {
            VStack {
                HStack{
                    Text(session.date as Date, style: .date)
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    
                    Text(session.type ?? "Session")
                        .font(.title)
                    Spacer()
                }
                
                ScrollView {
                    VStack {
                        LineView(data: session.data, title: "Pitch")
                        
//                        PieChartView(data: [0.7, 0.2, 0.1], title: "Proportion of Good Posture")
                    }
                }
            }
            .padding()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(session: Session(data: [1,2,5,6,0,10], date: Date() as NSDate, type: "Surgery"))
    }
}
