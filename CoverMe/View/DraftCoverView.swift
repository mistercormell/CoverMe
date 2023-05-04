//
//  CurrentCoverView.swift
//  CoverMe
//
//  Created by David Cormell on 09/03/2023.
//

import SwiftUI

struct DraftCoverView: View {
    @ObservedObject var viewModel: CoverPickerViewModel
    
    var draftCover: [CoverArrangementWithDate] {
        viewModel.coverRecord.filter({
            $0.status == .draft
        }).sorted()
    }
    
    var groupedByDate: [Date: [CoverArrangementWithDate]] {
        Dictionary(grouping: draftCover, by: {$0.startOfDayDate})
    }

    var headers: [Date] {
        groupedByDate.map({ $0.key }).sorted()
    }
    
    var body: some View {
        VStack {
            if draftCover.count <= 0 {
                Text("No Pending Cover Requests")
            } else {
                List {
                    ForEach(headers, id: \.self) { header in
                        Section(header: Text(header, style: .date)) {
                            ForEach(groupedByDate[header]!) { cover in
                                CoverRowItem(cover: cover, vm: viewModel, isDraftCoverRow: true)
                            }
                            Button("Send Email") {
                                sendEmail(groupedByDate[header]!, date: header)
                            }
                        }
                    }
                }
            }

        }

    }
    
    func sendEmail(_ coverArrangements: [CoverArrangementWithDate], date: Date) {
        let mailToUrl = MailHandler.draftCoverEmail(coverArrangements, date: date)
        if UIApplication.shared.canOpenURL(mailToUrl) {
                UIApplication.shared.open(mailToUrl, options: [:])
        }
    }
}

struct CurrentCoverView_Previews: PreviewProvider {
    static var previews: some View {
        DraftCoverView(viewModel: CoverPickerViewModel(selectedDepartment: .ComputerScience))
    }
}
