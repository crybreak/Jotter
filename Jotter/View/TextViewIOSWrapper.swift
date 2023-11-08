//
//  TextViewIOSWrapper.swift
//  Jotter
//
//  Created by macbook on 08/11/2023.
//

import SwiftUI

struct TextViewIOSWrapper: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        
        view.allowsEditingTextAttributes = true
        view.isEditable = true
        view.font = UIFont.systemFont(ofSize: 18)
        
        view.layer.borderWidth = 1;
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 5
        
        view.textStorage.setAttributedString(NSAttributedString)
        return view;
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
    
    }
    
}
   


//
//struct TextViewIOSWrapper_Previews: PreviewProvider {
//    static var previews: some View {
//        TextViewIOSWrapper()
//    }
//}
