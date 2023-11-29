//
//  macOS.swift
//  Jotter
//
//  Created by macbook on 09/11/2023.
//

import SwiftUI

typealias UIImage = NSImage

extension Image {

    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}


