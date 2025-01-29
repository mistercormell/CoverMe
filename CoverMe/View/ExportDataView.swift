//
//  ExportDataView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 28/01/2025.
//

import SwiftUI

struct ExportDataView: View {
    @State var startDate: Date
    @State private var endDate = Date()
    let confirmedCover: [CoverArrangementWithDate]
    let csvGenerator = CSVGenerator()
    
    var body: some View {
        Form {
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            
            Section {
                ShareLink(item: csvGenerator.generateCSV(confirmedCover: confirmedCover, start: startDate, end: endDate)) {
                    Text("Export to Excel")
                }
            }
        }
    }
}

#Preview {
    ExportDataView(startDate: Date.now, confirmedCover: [])
}
