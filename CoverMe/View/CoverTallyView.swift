//
//  CoverTallyView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 21/03/2023.
//

import SwiftUI

struct CoverTallyView: View {
    let teacherCoverTally: [Teacher:Int]
    
    var body: some View {
        List {
            ForEach(teacherCoverTally.sorted(by: <), id: \.key) { (key, value) in
                HStack {
                    Text("\(key.initials)")
                    Spacer()
                    Text("\(value )")
                }
            }
        }
    }
}

struct CoverTallyView_Previews: PreviewProvider {
    static var previews: some View {
        CoverTallyView(teacherCoverTally: [
            Teacher(initials: "DPC"):13,
            Teacher(initials: "JWFS"):9
        ])
    }
}
