//
//  Note+Helper.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import Foundation
import CoreData
import UniformTypeIdentifiers

#if os(OSX)
import AppKit
#endif

//MARK: Models

extension Note {
    
    #if os(OSX)

    static let importImageTypes = NSImage.imageTypes.compactMap { UTType($0)}
    
    #else
    static let importImageTypes = [UTType]()
    #endif
    
    var uuid: UUID  {
        #if DEBUG
        self.uuid_!
        #else
        self.uuid_ ?? UUID()
        #endif
    }
    
    var title: String {
        get {self.title_ ?? ""}
        set (newValue) {self.title_ = newValue.capitalized}
    }
    
    
    @objc var sectionLetterTitle: String {
        get {
            if let title = self.title_, !title.isEmpty {
                String(title.first!)
            } else {
                ""
            }
        }
    }
    
    var status: Status {
        get {
            if let rawStatus = self.status_, let status = Status(rawValue: rawStatus) {
                return status
            } else {
                return Status.draft
            }
        } set  { self.status_ = newValue.rawValue }
    }
    
    @objc var sectionStatus: String {
        get {status_ ?? Status.draft.rawValue}
    }
    
    var formattedBodyText: NSAttributedString {
        get {
            self.formattedBodyText_?.toAttributedString() ?? NSAttributedString(string: "")
        }
        set {
            self.formattedBodyText_ = newValue.toData()
            self.bodyText_ = newValue.string.lowercased()
        }
    }
    
    var bodyText: String {
        get { self.bodyText_ ?? "" }
    }
    
    var creationDate: Date {
        get { self.creationDate_ ?? Date() }
    }
   
    @objc var day: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: creationDate)
        return "\(components.year!)-\(components.month!)-\(components.day!)"
    }
   
    
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
    }
    
    public override func awakeFromInsert() {
        self.creationDate_ = Date() + TimeInterval()
        self.status = .draft
        self.uuid_ = UUID()
    }
    
    static func fetch(_ predicate: NSPredicate ) -> NSFetchRequest<Note> {
        let request = NSFetchRequest<Note>(entityName: "Note")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.creationDate_, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func fetch(for folder: Folder) -> NSFetchRequest<Note> {
        let predicate = NSPredicate(format: "%K == %@", NoteProperties.folder, folder)
        
        return Note.fetch(predicate)
    }
    
    static func fetch(for folder: Folder, status: Status? = nil) -> NSFetchRequest<Note> {
        let folderPredicate = NSPredicate(format: "%K == %@", NoteProperties.folder, folder)
        
        if let status = status {
            let statusPredicate = NSPredicate(format: "%K == %@", NoteProperties.status, status.rawValue as CVarArg)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, statusPredicate])
            return Note.fetch(predicate)
        }
        return Note.fetch(for: folder)
    }
    
    static func fetch(_ uuidString: String, context: NSManagedObjectContext)-> Note? {
        guard let uuid = UUID(uuidString: uuidString) else {return nil}
        return Note.fetch(uuid, context: context)
    }
    
    static func fetch (_ uuid: UUID, context: NSManagedObjectContext) -> Note? {
        let predicate = NSPredicate(format:  "%K == %@", NoteProperties.uuid, uuid as CVarArg)
        let request = Note.fetch(predicate)
        request.fetchLimit = 1
        
        if let notes = try? context.fetch(request), let note = notes.first {
            return note
        } else {
            return nil
        }
    }
    
    static func createFetchRequest(_ uuid: UUID) -> NSFetchRequest<Note> {
        let predicate = NSPredicate(format: "%K == %@", NoteProperties.uuid, uuid as CVarArg)
        let request = Note.fetch(predicate)
        request.fetchLimit = 1
        
        return request
    }
    
    static func delete(note: Note) {
        
        guard let context = note.managedObjectContext else {return}
        context.delete(note) 
    }
    
    func addImage(imageData: Data)  {
        if let attachment = self.attachment_ {
            attachment.fullImageData_ = imageData
            attachment.thumbnailData_ = nil
        } else {
            guard let context = self.managedObjectContext else {return}
            self.attachment_ = Attachment(image: imageData, context: context)
        }
    }
}


extension Note: Comparable {
    public static func < (lhs: Note, rhs: Note) -> Bool {
        lhs.creationDate < rhs.creationDate
    }
}

//MARK: RELATIONS

extension Note {

    var linkedNotes: Set<Note> {
        get { (self.linkedNotes_ as? Set<Note>) ?? []}
        set { self.linkedNotes_ = newValue as NSSet }
    }
               
    var keywords: Set<Keyword> {
        get { (self.keywords_ as? Set<Keyword>) ?? []}
        set{ self.keywords_ = newValue as NSSet}
    }
     
    var backLinkedNotes: Set<Note> {
        get {
            (self.backLinkedNotes_ as? Set<Note>) ?? []
        } set {
            self.backLinkedNotes_ = newValue as NSSet
        }
    }
        
}

//MARK: -define my string contants

struct NoteProperties {
    static let uuid = "uuid_"

    static let title = "title_"
    static let bodyText = "bodyText_"
    static let status = "status_"
    static let creationDate = "creationDate_"
    
    static let folder = "folder"
    static let keywords = "keywords_"
    static let attachment = "atachment_"
}

extension Note {
    
    //MARK: - Preview helper

    
    static func exampleArray(context: NSManagedObjectContext) -> [Note] {
        var notes = [Note]()
        let calendar = Calendar.current
        
        for index in 0..<10 {
            let newNote = Note(title: "note \(index)", context: context)
            newNote.creationDate_ = calendar.date(byAdding: .hour,  value: -(index * 10), to: Date())
            
            if index > 6 {
                newNote.status = Status.review
            } else if index >= 3 && index < 6 {
                newNote.status = Status.archieve
            }
            notes.append(newNote)
        }
        return notes
    }
    
    static func example() -> Note {
        let context = PersistenceController.preview.container.viewContext
    
        let note = Note(title: "my note", context: context)
        note.formattedBodyText = NSAttributedString(string: defaultText)
        
        let folder = Folder.nestedFolderExemple(context: context)
        let nestedFolder = folder.children.first
        note.folder = nestedFolder
        let keys = Keyword.exampleArray()
        for key in keys {
            note.keywords.insert(key)
        }
        let linkedNote = Note(title: "linked note", context: context)
        note.linkedNotes.insert(linkedNote)
        let linkedNote2 = Note(title: "other note", context: context)
        note.linkedNotes.insert(linkedNote2)
        return note
    }
    
    static func exampleLongFolder() -> Note {
        let context = PersistenceController.preview.container.viewContext
    
        let note = Note(title: "my note", context: context)
        note.formattedBodyText = NSAttributedString(string: defaultText)
        
        let folder1 = Folder(name: "first folder", context: context)
        let folder2 = Folder(name: "second folder", context: context)
        let folder3 = Folder(name: "something small", context: context)
        
        folder1.children.insert(folder2)
        folder2.children.insert(folder3)
        folder3.notes.insert(note)
        
        return note
        
        
    }
    
    static let defaultText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue. Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit sodales. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque fermentum. Maecenas adipiscing ante non diam sodales hendrerit"
    
    
}
