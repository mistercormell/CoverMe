//
//  ConfirmedCoverView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 21/03/2023.
//

import SwiftUI

struct ConfirmedCoverView: View {
    @ObservedObject var viewModel: CoverPickerViewModel
    
    var confirmedCover: [CoverArrangementWithDate] {
        viewModel.coverRecord.filter({
            $0.status == .confirmed
        })
    }
    
    var groupedByDate: [Date: [CoverArrangementWithDate]] {
        Dictionary(grouping: confirmedCover, by: {$0.startOfDayDate})
    }

    var headers: [Date] {
        groupedByDate.map({ $0.key }).sorted()
    }

    
    var body: some View {
        VStack {
            List {
                ForEach(headers, id: \.self) { header in
                    Section(header: Text(header, style: .date)) {
                        ForEach(groupedByDate[header]!) { cover in
                            CoverRowItem(cover: cover, vm: viewModel, isDraftCoverRow: false)
                        }
                    }
                }
            }
        }
    }
}

struct ConfirmedCoverView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmedCoverView(viewModel: CoverPickerViewModel())
    }
}
