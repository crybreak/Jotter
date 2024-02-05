//
//  FolderDragItem.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 10/01/2024.
//

import Foundation
import UniformTypeIdentifiers

class FolderDragItem: NSObject, Codable {
    
    var id: UUID?
    
    required init(id: UUID?) {
        self.id = id
    }
    
    required init(_ info: FolderDragItem)  {
        self.id = info.id
        super.init()
    }
}

//make it draggable


extension FolderDragItem: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [UTType.jotterFolder.identifier]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
        
        let progress = Progress(totalUnitCount: 100)
        do {
            let coder = JSONEncoder()
            let myJSON = try coder.encode(self)
            progress.completedUnitCount = 100
            completionHandler(myJSON, nil)
            
        } catch {
            print("error \(error.localizedDescription)")
            completionHandler(nil, error)
        }
        
        return progress
    }
}

extension FolderDragItem: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [UTType.jotterFolder.identifier]

    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let decoder = JSONDecoder()
        
        do {
            let item = try decoder.decode(FolderDragItem.self, from: data)
            return self.init(item)
        } catch  {
            throw error
        }
    }
    
}
