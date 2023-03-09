//
//  SelectedCoverView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 08/02/2023.
//

import SwiftUI

struct SelectedCoverView: View {
    @State var coverDetail: String
    var date: Date
    let email: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text(coverDetail)
                .multilineTextAlignment(.center)
            Button("Email Cover Request", action: {
                sendEmail()
            })
        }
        .padding()
    }
    
    func sendEmail() {
        let mailtoString = "mailto:\(email)?subject=COVER REQUEST: \(coverDetail)&body=Please can you let me know ASAP if it is not possible for you to cover the request given in the subject line.\n\n Best wishes,\nDave".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoUrl = URL(string: mailtoString!)!
        if UIApplication.shared.canOpenURL(mailtoUrl) {
                UIApplication.shared.open(mailtoUrl, options: [:])
        }
    }
}

struct SelectedCoverView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedCoverView(coverDetail: "Monday 2nd - BComV-1 (MC) - DPC to cover in 1 Keate", date: Date.now, email: "d.cormell@etoncollege.org.uk")
    }
}
