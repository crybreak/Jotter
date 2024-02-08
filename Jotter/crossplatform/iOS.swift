//
//  iOS.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 31/01/2024.
//

import Foundation
import UIKit

extension UIPasteboard {
    func copyText(_ text: String) {
        self.string = text
    }
}
