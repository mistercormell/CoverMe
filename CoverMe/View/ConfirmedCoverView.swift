//
//  ConfirmedCoverView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 21/03/2023.
//

import SwiftUI

struct ConfirmedCoverView: View {
    @ObservedObject var viewModel: CoverPickerViewModel
    @State private var showingTallyPopover = false
    
    var confirmedCover: [CoverArrangementWithDate] {
        viewModel.coverRecord.filter({
            $0.status == .confirmed
        }).sorted()
    }
    
    var confirmedCoverFuture: [CoverArrangementWithDate] {
        confirmedCover.filter({
            $0.date.startOfDayDate >= Date.now.startOfDayDate
        })
    }
    
    var groupedByDate: [Date: [CoverArrangementWithDate]] {
        Dictionary(grouping: confirmedCover, by: {$0.startOfDayDate})
    }

    var headers: [Date] {
        groupedByDate.map({ $0.key }).sorted()
    }

    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    List {
                        ForEach(headers, id: \.self) { header in
                            Section(header: Text(header, style: .date)) {
                                ForEach(groupedByDate[header]!) { cover in
                                    CoverRowItem(cover: cover, vm: viewModel, isDraftCoverRow: false)
                                }
                            }.id(header)
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(getNearestDateToToday(), anchor: .top)
                    }
                }
            }
            .toolbar {
                Button {
                    showingTallyPopover = true
                } label: {
                    Image(systemName: "chart.pie")
                }
                Button {
                    sendEmail()
                } label: {
                    Image(systemName: "envelope")
                }
            }
        }
        .popover(isPresented: $showingTallyPopover) {
            CoverTallyView(teacherCoverTally: viewModel.getCoverTally())
        }

    }
    
    func sendEmail() {
        let mailToUrl = MailHandler.coverConfirmationEmail(futureCoverArrangements: confirmedCoverFuture)
        if UIApplication.shared.canOpenURL(mailToUrl) {
                UIApplication.shared.open(mailToUrl, options: [:])
        }
    }
    
    func getNearestDateToToday() -> Date {
        let today = Date.now.startOfDayDate
        var dateToReturn = today
        for date in headers {
            if date >= today {
                return dateToReturn
            }
            dateToReturn = date
        }
        return today
    }
}

struct ConfirmedCoverView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmedCoverView(viewModel: CoverPickerViewModel())
    }
}
