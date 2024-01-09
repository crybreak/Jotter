//
//  NoteAttachementView.swift
//  Jotter
//
//  Created by macbook on 16/11/2023.
//

import SwiftUI
import CoreData

struct NoteAttachementView: View {
    @ObservedObject var attachment: Attachment
    
    @State private var showFullImage: Bool = false
    @State private var thumbnailImage: UIImage? = nil
    @State private var attachmentID: NSManagedObjectID? = nil
    
    @Environment(\.pixelLength) var pixelLength
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        
        Group {
            if let image = thumbnailImage {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .contextMenu {
                        Button {
                            Attachment.delete(attachment)
                        } label: {
                            Text("Delete Attachement")
                        }

                    }
                    .onDrag({NSItemProvider(object: image)})
                    .gesture(TapGesture(count: 2).onEnded({ _ in
                        showFullImage.toggle()
                    }))
                    .sheet(isPresented: $showFullImage) {
                        FullImageView(attachment: attachment, title: "full image \(dataSize(data: attachment.fullImageData_)) KB" )
                    }
            } else {
                ProgressView("Loding Image...")
                    .frame(minWidth: 300, minHeight: 300)
            }
        }.frame(width: attachment.imageWidth() * pixelLength,
                height: attachment.imageHeight() * pixelLength)
        
        .task(id: attachment.objectID) {
            thumbnailImage = nil
            thumbnailImage = await attachment.getThumbnail()
            attachment.updateImageSize(to: thumbnailImage?.size)
        }
    }
}

func dataSize(data: Data?) -> Int {
    if let data = data {
        return data.count / 1024
    } else {
        return 0
    }
}

private struct FullImageView: View {
    
    let attachment: Attachment
    let title: String
    @State private var image: UIImage? = nil
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                Button("Done") {
                    dismiss()
                }
            }
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView("Loding Image...")
                    .frame(minWidth: 300, minHeight: 300)
            }
        }.padding()
            .task {
                self.image = await attachment.createFullImage()
            }
        
    }
}
