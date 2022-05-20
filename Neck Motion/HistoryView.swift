//
//  HistoryView.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: DetailView(session: Session(data: [1,2,5,6,0,10], date: Date() as NSDate, type: "Surgery"))) {
                    HistoryListItem(session: Session(data: [1,2,5,6,0,10], date: Date() as NSDate, type: "Surgery"))
                }
                NavigationLink(
                    destination: DetailView(session: Session(data: [1,2,5,6,0,10], date: Date() as NSDate, type: "Surgery"))) {
                    HistoryListItem(session: Session(data: [1,2,5,6,0,10], date: Date() as NSDate, type: "Surgery"))
                }
                
            }
            .navigationTitle("Past Sessions")
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
