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
    
    var body: some View {
        List {
            ForEach(confirmedCover) { cover in
                Text("\(cover.coverArrangement.display)")
            }
        }
    }
}

struct ConfirmedCoverView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmedCoverView(viewModel: CoverPickerViewModel())
    }
}
