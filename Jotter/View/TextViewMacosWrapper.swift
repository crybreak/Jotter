//
//  TextViewMacosWrapper.swift
//  Jotter
//
//  Created by macbook on 08/11/2023.
//

import SwiftUI
import AppKit


struct TextViewMacosWrapper: NSViewRepresentable {
    let note: Note
    
    func makeCoordinator() -> Coordinator {
        Coordinator(note: note, parent: self)
    }
   
    func makeNSView(context: Context) -> NSTextView {
        let view = NSTextView()
        
        view.isRichText = true
        view.isEditable = true
        view.isSelectable = true
        view.allowsUndo = true

        view.usesInspectorBar = true
        
        view.usesFindPanel = true
        view.usesFindBar = true
        view.isGrammarCheckingEnabled = true
        
        view.isRulerVisible = true
        
        view.delegate = context.coordinator
        return view
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(note.formattedBodyText)
        context.coordinator.note = note
        
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var note: Note
        let parent: TextViewMacosWrapper
        
        init( note: Note, parent: TextViewMacosWrapper) {
            self.note = note
            self.parent = parent
        }
        
        
        func textDidChange(_ notification: Notification) {
            if let textview = notification.object as? NSTextView {
                note.formattedBodyText = textview.attributedString()
            }
        }
    }
}

struct TextViewMacosWrapper_Previews: PreviewProvider {
    static var previews: some View {
        TextViewMacosWrapper(note: Note(title: "new", context: PersistenceController.preview.container.viewContext))
    }
}



