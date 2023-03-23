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
        Text("\(cover.coverArrangement.display)")
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
        CoverRowItem(cover: CoverArrangementWithDate(coverArrangement: CoverArrangement(originalTeacher: Teacher(initials: "DPC"), coverTeacher: Teacher(initials: "MC"), room: Room.Birley1, lesson: Lesson.Wednesday3rd, divisionCode: "BComV-1", notes: ""), date: Date.now), vm: CoverPickerViewModel(), isDraftCoverRow: true)
    }
}
