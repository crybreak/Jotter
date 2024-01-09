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
    
    var uuid: UUID  {
#if DEBUG
        uuid_!
#else
        self.uuid_ ?? UUID()
#endif
    }
    
    
    static let maxThumbnailPixelSize: Int = 600
    
    convenience init(image: Data?, context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.fullImageData_ = image
        
    }
    
    public override func awakeFromInsert() {
        self.uuid_ = UUID()
    }
    
    static func delete(_ attachment: Attachment?) {
        guard let attachment,
                let context = attachment.managedObjectContext else {return}
        context.delete(attachment)
    }
    
}
 
// MARK: create Thumbnail image
extension Attachment {
    static func createThumbnailThroughtImage(from imageData: Data, thumbmailPixelSize: Int) -> UIImage? {
        
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
    
    
    func getThumbnail() async -> UIImage? {
        
        guard self.thumbnailData_ == nil else {
            return UIImage(data: thumbnailData_!)
        }
        guard let fullImageData = self.fullImageData_ else {
            return nil
        }
        let imageThumbnail = await Task (priority: .medium) {
            Attachment.createThumbnailThroughtImage(from: fullImageData,
                                                    thumbmailPixelSize: Attachment.maxThumbnailPixelSize)
        }.value
        
        
        
        Task (priority: .low){
#if os(iOS)
        self.thumbnailData_ = imageThumbnail?.pngData()
#else
        self.thumbnailData_ = imageThumbnail?.tiffRepresentation
#endif
        }
        return imageThumbnail
    }
    
    
    static func createiImage(from imageData: Data) async -> UIImage? {
       let image = await Task(priority: .background) {
            UIImage(data: imageData)
       }.value
        
        return image
    }
    
    func createFullImage() async -> UIImage? {
        
        guard let data = self.fullImageData_ else {return nil}
        let image = await Attachment.createiImage(from: data)
        return image
    }
    
    func updateImageSize(to newSize: CGSize?) {
        if let newHeight = newSize?.height,
           self.height != Float(newHeight) {
            self.height = Float(newHeight)
        }
        
        if let newWidth = newSize?.width,
        self.width != Float(newWidth) {
            self.width = Float(newWidth)
        }
    }
    
    func imageWidth() -> CGFloat {
        if self.width > 0 {
            return CGFloat(self.width)
        } else {
            return CGFloat(Attachment.maxThumbnailPixelSize)
        }
    }
    
    func imageHeight() -> CGFloat {
        if self.height > 0 {
            return CGFloat(self.height)
        } else {
            return CGFloat(Attachment.maxThumbnailPixelSize)
        }
    }

}


struct AttachementProperties {
    static let uuid = "uuid_"

}
