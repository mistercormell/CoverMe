//
//  MailHandler.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 23/03/2023.
//

import Foundation

class MailHandler {
    static func mailToUrl(_ coverArrangements: [CoverArrangementWithDate], date: Date) -> URL {
        let emails = Set(coverArrangements.map({ $0.coverArrangement.coverTeacher.getEmail()}))
        let emailSequence = emails.joined(separator: ",")
        
        let coverDetails = coverArrangements.map({ $0.coverArrangement.display })
        let coverDetailsMessage = coverDetails.joined(separator: "\n")
        
        let mailtoString = "mailto:\(emailSequence)?subject=COVER REQUESTS FOR: \(date.longDateDescription)&body=Please can you respond and let me know if you can or can't cover the request/s shown below. Any subsequent email overrides any previously communicated cover requests for this day: \(date.longDateDescription)\n\n \(coverDetailsMessage)\n\n Best wishes,\nDave".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoUrl = URL(string: mailtoString!)!

        return mailtoUrl
    }
    
    static func coverConfirmationEmail(futureCoverArrangements: [CoverArrangementWithDate]) -> URL {
        let coverEmails = Set(futureCoverArrangements.map({ $0.coverArrangement.coverTeacher.getEmail()}))
        let coveredEmails = Set(futureCoverArrangements.map({ $0.coverArrangement.originalTeacher.getEmail()}))
        let emails = coverEmails.union(coveredEmails)
        let emailSequence = emails.joined(separator: ",")
        
        let coverDetails = futureCoverArrangements.map({ $0.display})
        let coverDetailsMessage = coverDetails.joined(separator: "\n")
        
        let mailtoString = "mailto:\(emailSequence)?subject=CONFIRMED Cover From: \(Date.now.longDateDescription) Onwards&body=Dear All,\n\nThank you to those shown below who have agreed to provide cover. \n\nIf you are being covered for any of the schools below, please contact the relevant master/s detailing what needs to be covered, if you haven't already.\n\n \(coverDetailsMessage)\n\n Best wishes,\nDave".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoUrl = URL(string: mailtoString!)!

        return mailtoUrl
    }
}
