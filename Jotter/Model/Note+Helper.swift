//
//  Note+Helper.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import Foundation
import CoreData

extension Note {
    var title: String {
        get {self.title_ ?? ""}
        set (newValue) {self.title_ = newValue}
    }
    
    var status: Status {
        get {
            if let rawStatus = self.status_, let status = Status(rawValue: rawStatus) {
                return status
            } else {
                return Status.draft
            }
        } set (newValue) {
            status_ = newValue.rawValue
        }
    }
    
    var formattedBodyText: NSAttributedString {
        get {
            NSAttributedString()
        } set {
        }
    }
    
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        
        PersistenceController.shared.save()
    }
    
    public override func awakeFromInsert() {
        self.creationDate = Date() + TimeInterval()
    }
    
    static func fetch(_ predicate: NSPredicate ) -> NSFetchRequest<Note> {
        let request = NSFetchRequest<Note>(entityName: "Note")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.creationDate, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func delete(note: Note) {
        
        guard let context = note.managedObjectContext else {return}
        context.delete(note) 
    }
}
