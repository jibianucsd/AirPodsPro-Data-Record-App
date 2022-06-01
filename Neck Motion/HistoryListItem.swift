//
//  HistoryListItem.swift
//  Neck Motion
//
//  Created by Daniel Ziper on 5/19/22.
//

import SwiftUI

struct HistoryListItem: View {
    @State var session: Session
    var body: some View {
        HStack {
            Image(systemName: "chart.xyaxis.line")
                .font(.title)
            VStack {
                HStack {
                    Text(session.date as Date, style: .date)
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text(session.type)
                    Spacer()
                }
                
            }
            .padding()
        }
    }
}

struct HistoryListItem_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListItem(session: generateRandomSession())
    }
}
