//
//  TextViewIOSWrapper.swift
//  Jotter
//
//  Created by macbook on 08/11/2023.
//

import SwiftUI

struct TextViewIOSWrapper: UIViewRepresentable {
    
    let note: Note
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, note: note)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        
        view.allowsEditingTextAttributes = true
        view.isEditable = true
        view.font = UIFont.systemFont(ofSize: 18)
        
        view.layer.borderWidth = 1;
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 5
        
        view.textStorage.setAttributedString(note.formattedBodyText)
        view.delegate = context.coordinator
        
        return view;
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.textStorage.setAttributedString(note.formattedBodyText)
        context.coordinator.note = note
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var note: Note
        let parent:  TextViewIOSWrapper
        
        init(_ parent: TextViewIOSWrapper, note: Note) {
            self.parent = parent
            self.note = note
        }
        
        func textViewDidChange(_ textView: UITextView) {
            note.formattedBodyText = textView.attributedText
        }
    }
    
}

