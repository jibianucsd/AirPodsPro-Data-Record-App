//
//  HistoryView.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        NavigationView {
            // Scrollable session buttons, linking to DetailViews of each session
            
            List (model.sessions.reversed()) { session in
                NavigationLink(
                    destination: DetailView(session: session)) {
                    HistoryListItem(session: session)
                }
            }
            .navigationTitle("Past Sessions")
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject({ () -> Model in
                            let model = Model()
                
                            let session1 = generateRandomSession()
                            let session2 = generateRandomSession()
                            model.sessions.append(session1)
                            model.sessions.append(session2)
                
                            return model
                        }() )
    }
}
