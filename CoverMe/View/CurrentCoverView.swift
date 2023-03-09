//
//  CurrentCoverView.swift
//  CoverMe
//
//  Created by David Cormell on 09/03/2023.
//

import SwiftUI

struct CurrentCoverView: View {
    @ObservedObject var viewModel: CoverPickerViewModel
    
    var groupedByDate: [Date: [CoverArrangementWithDate]] {
        Dictionary(grouping: viewModel.coverRecord, by: {$0.startOfDayDate})
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
                            Text("\(cover.coverArrangement.display)")
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
        
        let mailtoString = "mailto:\(emailSequence)?subject=COVER REQUESTS FOR: \(date.description)&body=Please can you let me know ASAP if it is not possible for you to cover the requests shown below. Any subsequent email overrides any previously communicated cover requests.\n\n \(coverDetailsMessage)\n\n Best wishes,\nDave".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoUrl = URL(string: mailtoString!)!
        if UIApplication.shared.canOpenURL(mailtoUrl) {
                UIApplication.shared.open(mailtoUrl, options: [:])
        }
    }
}

struct CurrentCoverView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentCoverView(viewModel: CoverPickerViewModel())
    }
}
