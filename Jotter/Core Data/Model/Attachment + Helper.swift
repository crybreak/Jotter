//
//  Attachment + Helper.swift
//  Jotter
//
//  Created by macbook on 16/11/2023.
//

import Foundation
import CoreData

#if os(OSX)
import AppKit
#else
import UIKit
#endif


extension Attachment {
    
    
    
    var thumbnailData: Data? {
        get {
            self.thumbnailData_ ?? nil }
        set {
            getThumbnail(image: newValue)
        }
    }
    
    convenience init(image: Data?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.fullImageData_ = image
        self.getThumbnail(image: self.fullImageData_    )
        
        PersistenceController.shared.save()
    }

    
    
    static func createThumbnail(from imageData: Data, thumbmailPixelSize: Int) -> UIImage? {
        
        let options = [kCGImageSourceCreateThumbnailWithTransform: true,
                     kCGImageSourceCreateThumbnailFromImageAlways: true,
                              kCGImageSourceThumbnailMaxPixelSize: thumbmailPixelSize] as [CFString : Any]  as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil), let imageReference = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) else {return nil}
#if os(iOS)
        return UIImage(cgImage: imageReference)
#else
        return UIImage(cgImage: imageReference, size: .zero)
#endif
    }
        
    private func getThumbnail(image: Data?) {
        
        guard let fullImageData = image,
              let imageThumbnail = Attachment.createThumbnail(from: fullImageData, thumbmailPixelSize: 200) else  {return}
#if os(iOS)
        self.thumbnailData_ = imageThumbnail.pngData()
#else
        self.thumbnailData_ = imageThumbnail.tiffRepresentation
#endif
            
    }
    
}
