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
    
    var uuid: UUID  {
        #if DEBUG
        uuid_!
        #else
        self.uuid_ ?? UUID()
        #endif
    }

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
    }
    
    public override func awakeFromInsert() {
        self.creationDate_ = Date() + TimeInterval()
        self.uuid_ = UUID()
    }
    
    var creationDate: Date {
        get { self.creationDate_ ?? Date() }
    }
   
    
    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Folder> {
        
        let request = NSFetchRequest<Folder>(entityName: "Folder")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Folder.creationDate_, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func topFolderFetch() -> NSFetchRequest<Folder> {
        
        let predicate = NSPredicate(format: "%K == nil", FolderProperties.parent)
        return Folder.fetch(predicate)
    }
    
    static func fetch(_ uuidString: String, context: NSManagedObjectContext) -> Folder? {
        
        guard let uuid = UUID(uuidString: uuidString) else {return nil}
        return Folder.fetch(uuid, context: context)
    }
    
    static func fetch(_ uuid: UUID, context: NSManagedObjectContext)-> Folder? {
        
        let predicate = NSPredicate(format: "%K == %@", FolderProperties.uuid, uuid as CVarArg)
        let request = Folder.fetch(predicate)
        request.fetchLimit = 1
        
        if let folders = try? context.fetch(request), let folder = folders.first {
            return folder
        }
        return nil
    }
    
    static func delete(_ folder: Folder) {
        
        guard let context = folder.managedObjectContext else {return}
        context.delete(folder)
    }
    
    func allFolderPath() ->  [Folder] {
        var parents = [Folder]()
        var parentFolder = self.parent
        
        while parentFolder != nil {
            parents.append(parentFolder!)
            parentFolder = parentFolder?.parent
        }
        return parents
    }
    
    func fullFolderPath() -> [Folder] {
        
        var parents = allFolderPath()
        
        parents = parents.reversed()
        parents.append(self)
        return parents
    }
    
    func handle(providers: [NSItemProvider]) -> Bool {
        
        guard let context = managedObjectContext else {return false}
        
        var found = providers.loadFirstObject(ofType: NoteDragItem.self) { droppedNoteItem in
            guard let uuid = droppedNoteItem.id,
                  let droppedNote = Note.fetch(uuid, context: context) else {return}
            guard droppedNote.folder != self else {return}
            self.notes.insert(droppedNote)
        }
        
        if  found == false {
                   found = providers.loadFirstObject(ofType: FolderDragItem.self, using: { droppedFolderItem in
                guard let uuid = droppedFolderItem.id,
                      let droppedFolder = Folder.fetch(uuid, context: context) else {return}
                self.children.insert(droppedFolder)
            })
            
        }
        return found
    }
}


extension Folder: Comparable {
    public static func < (lhs: Folder, rhs: Folder) -> Bool {
        lhs.creationDate < rhs.creationDate
    }
}

//MARK: - define my string constants


struct FolderProperties {
    static let uuid = "uuid_"

    static let parent = "parent"
    static let children = "children_"
    static let name = "name_"
}

extension Folder {
    //MARK: - preview
    
    static func nestedFolderExemple(context: NSManagedObjectContext) -> Folder {
        let parent = Folder(name: "parent", context: context)
        let child1 = Folder(name: "child 1", context: context)
        let child2 = Folder(name: "child 2", context: context)
        let child3 = Folder(name: "child 3", context: context)

        parent.children.insert(child1)
        parent.children.insert(child2)
        child2.children.insert(child3)
        
        child3.notes.insert(Note(title: "mynote", context: context))

        return parent
    }
    
    static func exampleWithNotes(context: NSManagedObjectContext) -> Folder {
        
        let folder = Folder(name: "New Folder", context: context)
        
        let notes = Note.exampleArray(context: context)
        for note in notes {
            folder.notes.insert(note)
        }
        return folder
    }
}
