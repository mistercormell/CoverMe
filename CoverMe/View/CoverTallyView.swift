//
//  CoverTallyView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 21/03/2023.
//

import SwiftUI

struct CoverTallyView: View {
    let teacherCoverTally: [(Teacher, Tally)]
    let readerTally: (Int, Int)
    let reasonCoverTally: [(ReasonForCover, Tally)]
    
    var body: some View {
        List {
            ForEach(teacherCoverTally.sorted(by: {
                $0.1.currentHalf < $1.1.currentHalf}), id: \.0) { (teacher, tally)  in
                CoverTallyItemView(key: teacher.initials, allTime: tally.allTime, currentHalf: tally.currentHalf)
            }
            Section {
                CoverTallyItemView(key: "Readers", allTime: readerTally.1, currentHalf: readerTally.0)
            }
            Section {
                ForEach(reasonCoverTally.sorted(by: {
                    $0.1.currentHalf < $1.1.currentHalf}), id: \.0) { (reason, tally)  in
                        CoverTallyItemView(key: reason.rawValue, allTime: tally.allTime, currentHalf: tally.currentHalf)
                }
            }
        }
    }
}

struct CoverTallyItemView: View {
    let key: String
    let allTime: Int
    let currentHalf: Int
    
    
    var body: some View {
        HStack {
            Text(key)
                .frame(minWidth:200,alignment: .leading)
            Spacer()
            HStack {
                Divider()
                Text("\(currentHalf)")
                    .padding(.trailing, 20)
                Divider()
                Text("\(allTime)")
                    .padding(.leading, 10)
                Spacer()
            }
        }

    }
}

struct CoverTallyView_Previews: PreviewProvider {
    static var previews: some View {
        CoverTallyView(teacherCoverTally: [
            (Teacher(initials: "DPC", department: .ComputerScience, email: "d.cormell@etoncollege.org.uk"), Tally(currentHalf: 9, allTime: 15)),
            (Teacher(initials: "SJT", department: .ComputerScience, email: "s.tebbutt@etoncollege.org.uk"), Tally(currentHalf: 3, allTime: 23)),
            (Teacher(initials: "MC", department: .ComputerScience, email: "m.collins@etoncollege.org.uk"), Tally(currentHalf: 0, allTime: 8)),
            (Teacher(initials: "JWFS", department: .ComputerScience, email: "j.stanforth@etoncollege.org.uk"), Tally(currentHalf: 9, allTime: 11))
        ], readerTally: (5, 14), reasonCoverTally: [(.health, Tally(currentHalf: 3, allTime: 12)),(.partnerships, Tally(currentHalf: 1, allTime: 9))])
    }
}
