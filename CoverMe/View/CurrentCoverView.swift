//
//  CurrentCoverView.swift
//  CoverMe
//
//  Created by David Cormell on 09/03/2023.
//

import SwiftUI

struct CurrentCoverView: View {
    @ObservedObject var viewModel: CoverPickerViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.coverRecord) { cover in
                Text("\(cover.coverArrangement.display)")
            }
        }
    }
}

struct CurrentCoverView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentCoverView(viewModel: CoverPickerViewModel())
    }
}
