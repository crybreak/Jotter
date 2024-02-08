//
//  NSAttributeString + Data + Helper.swift
//  Jotter
//
//  Created by macbook on 08/11/2023.
//

import Foundation

extension NSAttributedString {
    
    func toData() -> Data? {
        
        let options: [NSAttributedString.DocumentAttributeKey: Any] = [.documentType: NSAttributedString.DocumentType.rtf,
                                                                    .characterEncoding: String.Encoding.utf8]
        let range = NSRange(location: 0, length: length)
        let data = try? data(from: range, documentAttributes: options)
        
        return data
    }
}

extension Data {
    
    func toAttributedString() -> NSAttributedString? {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.rtf,.characterEncoding: String.Encoding.utf8]
        
        let nsAttributeString = try? NSAttributedString(data: self, options: options, documentAttributes: nil)
        
        return nsAttributeString
    }
}
