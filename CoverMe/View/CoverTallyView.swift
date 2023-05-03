//
//  CoverTallyView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 21/03/2023.
//

import SwiftUI

struct CoverTallyView: View {
    let teacherCoverTally: [Teacher:Int]
    let readerTally: Int
    
    var body: some View {
        List {
            ForEach(teacherCoverTally.sorted(by: <), id: \.key) { (key, value) in
                CoverTallyItemView(key: key.initials, value: value)
            }
            Section {
                CoverTallyItemView(key: "Readers", value: readerTally)
            }
        }
    }
}

struct CoverTallyItemView: View {
    let key: String
    let value: Int
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text("\(value)")
        }
    }
}

struct CoverTallyView_Previews: PreviewProvider {
    static var previews: some View {
        CoverTallyView(teacherCoverTally: [
            Teacher(initials: "DPC"):13,
            Teacher(initials: "JWFS"):9
        ], readerTally: 5)
    }
}
