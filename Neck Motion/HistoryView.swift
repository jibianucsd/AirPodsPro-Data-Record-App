//
//  HistoryView.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import SwiftUI

struct HistoryView: View {
    let sessions: [Session]
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: DetailView(session: sessions[0])) {
                    HistoryListItem(session: sessions[0])
                }
                NavigationLink(
                    destination: DetailView(session: sessions[1])) {
                    HistoryListItem(session: sessions[1])
                }
                
            }
            .navigationTitle("Past Sessions")
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let session1 = generateRandomSession()
        let session2 = generateRandomSession()
        let sessions = [session1, session2]
        HistoryView(sessions: sessions)
    }
}
