//
//  MailHandler.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 23/03/2023.
//

import Foundation

class MailHandler {
    private static func mailToUrl(recipients: Set<String>, subject: String, body: String, coverDetailsList: [String], senderName: String) -> URL {
        let emailSequence = recipients.joined(separator: ",")
        let coverDetailsMessage = coverDetailsList.joined(separator: "\n")
        
        let mailtoString = "mailto:\(emailSequence)?subject=\(subject)&body=\(body)\n\n \(coverDetailsMessage)\n\n Best wishes,\n\(senderName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoUrl = URL(string: mailtoString!)!

        return mailtoUrl
    }
    
    static func draftCoverEmail(_ coverArrangements: [CoverArrangementWithDate], date: Date) -> URL {
        let emails = Set(coverArrangements.map({ $0.coverArrangement.coverTeacher.getEmail()}))
        let coverDetails = coverArrangements.map({ $0.coverArrangement.display })
        let subject = "COVER REQUESTS FOR: \(date.longDateDescription)"
        let body = "Please can you respond and let me know if you can or can't cover the request/s shown below. Any subsequent email overrides any previously communicated cover requests for this day: \(date.longDateDescription)"
        
        return mailToUrl(recipients: emails, subject: subject, body: body, coverDetailsList: coverDetails, senderName: "Dave")
    }
    
    static func coverConfirmationEmail(futureCoverArrangements: [CoverArrangementWithDate]) -> URL {
        let coverEmails = Set(futureCoverArrangements.map({ $0.coverArrangement.coverTeacher.getEmail()}))
        let coveredEmails = Set(futureCoverArrangements.map({ $0.coverArrangement.originalTeacher.getEmail()}))
        let emails = coverEmails.union(coveredEmails)
        let coverDetails = futureCoverArrangements.sorted(by: {$0 < $1}).map({ $0.display})
        let subject = "CONFIRMED Cover From: \(Date.now.longDateDescription) Onwards"
        let body = "Dear All,\n\nThank you to those shown below who have agreed to provide cover. \n\nIf you are being covered for any of the schools below, please contact the relevant master/s detailing what needs to be covered, if you haven't already."
        
        return mailToUrl(recipients: emails, subject: subject, body: body, coverDetailsList: coverDetails, senderName: "Dave")
    }
}