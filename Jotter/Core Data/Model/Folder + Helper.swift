//
//  Folder + Helper.swift
//  Jotter
//
//  Created by macbook on 10/11/2023.
//
//
import Foundation
import CoreData

extension Folder {
    
    var name: String {
        get {self.name_ ?? ""}
        set {self.name_ = newValue}
    }
    
    var notes: Set<Note> {
        get { (self.notes_ as? Set<Note>) ?? [] }
        set {self.notes_ = newValue as NSSet}
    }
    
    var children: Set<Folder> {
        get {(self.children_ as? Set<Folder>) ?? []}
        set{self.children_ = newValue as NSSet}
    }
    
    convenience init (name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        PersistenceController.shared.save()
    }
    
    public override func awakeFromInsert() {
        self.creationDate = Date() + TimeInterval()
    }
    
    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Folder> {
        
        let request = NSFetchRequest<Folder>(entityName: "Folder")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Folder.creationDate, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func delete(_ folder: Folder) {
        
        guard let context = folder.managedObjectContext else {return}
        context.delete(folder)
    }
}
