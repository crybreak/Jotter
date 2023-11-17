//
//  NoteAttachementView.swift
//  Jotter
//
//  Created by macbook on 16/11/2023.
//

import SwiftUI

struct NoteAttachementView: View {
   @ObservedObject var attachment: Attachment
    
    @State private var showFullImage: Bool = false
    
    var body: some View {
        if let thumbnailData = attachment.thumbnailData {
            
            Text("thumbnail \(dataSize(data: thumbnailData))")
            
            Image(uiImage: UIImage(data: thumbnailData)!)
                .gesture(TapGesture(count: 2).onEnded({ _ in
                    showFullImage.toggle()
                }))
            
                .sheet(isPresented: $showFullImage) {
                    FullImageView(attachment: attachment, title: "full image \(dataSize(data: attachment.fullImageData_))" )
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
}

private struct FullImageView: View {

    let attachment: Attachment
    let title: String
    
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
            if let data = attachment.fullImageData_ , let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }.padding()
      
    }
}
//struct NoteAttachementView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteAttachementView()
//    }
//}
