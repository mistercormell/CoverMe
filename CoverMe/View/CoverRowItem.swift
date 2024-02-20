//
//  CoverRowItem.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 21/03/2023.
//

import SwiftUI

struct CoverRowItem: View {
    var cover: CoverArrangementWithDate
    @ObservedObject var vm: CoverPickerViewModel
    let isDraftCoverRow: Bool
    
    var body: some View {
        HStack {
            Text("\(cover.displayWithoutDate)")
            Image(systemName: cover.coverArrangement.reasonForCover.iconName)
        }
            .swipeActions(edge: .leading) {
                if isDraftCoverRow {
                    Button {
                        vm.confirmCover(cover)
                    } label: {
                        Label("Confirm", systemImage: "person.fill.checkmark")
                    }
                    .tint(.green)
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    vm.removeCoverFromRecord(cover)
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }

    }
}

struct CoverRowItem_Previews: PreviewProvider {
    static var previews: some View {
        CoverRowItem(cover: CoverArrangementWithDate(coverArrangement: CoverArrangement(originalTeacher: Teacher(initials: "DPC", department: .ComputerScience, email: "d.cormell@etoncollege.org.uk"), coverTeacher: Teacher(initials: "MC", department: .ComputerScience, email: "m.collins@etoncollege.org.uk"), room: Room.Birley1, lesson: Lesson.Wednesday3rd, divisionCode: "BComV-1", notes: "", isReadingSchool: false, reasonForCover: .health), date: Date.now, timetableTiming: .Normal), vm: CoverPickerViewModel(selectedDepartment: .ComputerScience), isDraftCoverRow: true)
    }
}
