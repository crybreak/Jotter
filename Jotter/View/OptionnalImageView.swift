//
//  OptionnalImageView.swift
//  Jotter
//
//  Created by macbook on 09/11/2023.
//

import SwiftUI

struct OptionnalImageView: View {
    let data: Data?
    
    var body: some View {
        if let data = data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            EmptyView()
        }
    }
}

//struct OptionnalImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        OptionnalImageView()
//    }
//}
