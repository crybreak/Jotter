//
//  TextViewMacosWrapper.swift
//  Jotter
//
//  Created by macbook on 08/11/2023.
//

import SwiftUI

struct TextViewMacosWrapper: NSViewRepresentable {
    let note: Note
    
    func makeCoordinator() -> Coordinator {
        Coordinator(note: note, self)
    }
   
    func makeNSView(context: Context) -> NSTextView {
        let view = NSTextView()
        
        view.isRichText = true
        view.isEditable = true
        view.isSelectable = true
        
        view.usesInspectorBar = true
        
        view.usesFindPanel = true
        view.usesFindBar = true
        view.isGrammarCheckingEnabled = true
        
        view.isRulerVisible = true
        
        view.delegate = context.coordinator
        view.textStorage?.setAttributedString(note.formattedBodyText)
        
        return view
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(note.formattedBodyText)
        context.coordinator.note = note
        
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var note: Note
        let parent: TextViewMacosWrapper
        
        init( note: Note, _ parent: TextViewMacosWrapper) {
            self.note = note
            self.parent = parent
        }
        
        func textViewDidChange(_ notification: Notification) {
            if let textview = notification.object as? NSTextView {
                note.formattedBodyText = textview.attributedString()
            }
        }
    }
}


