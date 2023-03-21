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
        })
    }
    
    var groupedByDate: [Date: [CoverArrangementWithDate]] {
        Dictionary(grouping: draftCover, by: {$0.startOfDayDate})
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
    
    func sendEmail(_ coverArrangements: [CoverArrangementWithDate], date: Date) {
        let emails = Set(coverArrangements.map({ $0.coverArrangement.coverTeacher.getEmail()}))
        let emailSequence = emails.joined(separator: ",")
        
        let coverDetails = coverArrangements.map({ $0.coverArrangement.display })
        let coverDetailsMessage = coverDetails.joined(separator: "\n")
        
        let mailtoString = "mailto:\(emailSequence)?subject=COVER REQUESTS FOR: \(date.longDateDescription)&body=Please can you respond and let me know if you can or can't cover the request/s shown below. Any subsequent email overrides any previously communicated cover requests for this day.\n\n \(coverDetailsMessage)\n\n Best wishes,\nDave".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoUrl = URL(string: mailtoString!)!
        if UIApplication.shared.canOpenURL(mailtoUrl) {
                UIApplication.shared.open(mailtoUrl, options: [:])
        }
    }
}

struct CurrentCoverView_Previews: PreviewProvider {
    static var previews: some View {
        DraftCoverView(viewModel: CoverPickerViewModel())
    }
}
