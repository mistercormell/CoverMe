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
    let teacherCoverStats: [(Teacher, CoverStatistic, CoverStatistic)]
    
    var body: some View {
        List {
            ForEach(teacherCoverStats.sorted(by: {
                $0.1.currentHalf < $1.1.currentHalf}), id: \.0) { (teacher, covered, requested)  in
                    CoverStatisticItemView(teacher: teacher.initials, covered: covered, requested: requested)
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

struct CoverStatisticItemView: View {
    let teacher: String
    let covered: CoverStatistic
    let requested: CoverStatistic
    
    var body: some View {
        HStack {
            Text(teacher)
                .frame(minWidth:120,alignment: .leading)
            Spacer()
            HStack {
                Divider()
                Text("\(covered.currentHalf)")
                    .padding(.trailing, 10)
                Divider()
                Text("\(covered.allTime)")
                    .padding(.trailing, 10)
                Divider()
                Text("\(requested.currentHalf)")
                    .padding(.trailing, 10)
                Divider()
                Text("\(requested.allTime)")
                    .padding(.leading, 10)
                Spacer()
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
        ], readerTally: (5, 14), reasonCoverTally: [(.health, Tally(currentHalf: 3, allTime: 12)),(.partnerships, Tally(currentHalf: 1, allTime: 9))], teacherCoverStats:[
            (
                Teacher(initials: "JDO", department: .ComputerScience, email: "jdo@school.edu"),
                CoverStatistic(currentHalf: 3, previousHalf: 5, priorToPreviousHalf: 4, allTime: 12),
                CoverStatistic(currentHalf: 2, previousHalf: 1, priorToPreviousHalf: 3, allTime: 6)
            ),
            (
                Teacher(initials: "AKM", department: .ComputerScience, email: "akm@school.edu"),
                CoverStatistic(currentHalf: 4, previousHalf: 2, priorToPreviousHalf: 6, allTime: 12),
                CoverStatistic(currentHalf: 1, previousHalf: 4, priorToPreviousHalf: 2, allTime: 7)
            ),
            (
                Teacher(initials: "SBL", department: .ComputerScience, email: "sbl@school.edu"),
                CoverStatistic(currentHalf: 1, previousHalf: 3, priorToPreviousHalf: 2, allTime: 6),
                CoverStatistic(currentHalf: 5, previousHalf: 2, priorToPreviousHalf: 3, allTime: 10)
            ),
            (
                Teacher(initials: "RHW", department: .ComputerScience, email: "rhw@school.edu"),
                CoverStatistic(currentHalf: 6, previousHalf: 4, priorToPreviousHalf: 3, allTime: 13),
                CoverStatistic(currentHalf: 2, previousHalf: 3, priorToPreviousHalf: 4, allTime: 9)
            ),
            (
                Teacher(initials: "PMT", department: .ComputerScience, email: "pmt@school.edu"),
                CoverStatistic(currentHalf: 2, previousHalf: 3, priorToPreviousHalf: 5, allTime: 10),
                CoverStatistic(currentHalf: 3, previousHalf: 2, priorToPreviousHalf: 1, allTime: 6)
            )
        ])
    }
}
