//
//  FileManager.swift
//  Movieflex
//
//  Created by Shubham Singh on 17/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import Foundation

struct FileHandler {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    func getPathForImage(titleId: String) -> URL {
        let pathComponent = "\(titleId).jpg"
        return documentsDirectory.appendingPathComponent(pathComponent)
    }
    
    func checkIfFileExists(titleId: String) -> Bool {
        let pathComponent = "\(titleId).jpg"
        return FileManager.default.fileExists(atPath: documentsDirectory.appendingPathComponent(pathComponent).path)
    }
    
    func flushDocumentsDirectory() -> Bool {
        guard let paths = try? FileManager.default.contentsOfDirectory(at: self.documentsDirectory, includingPropertiesForKeys: nil) else { return false }
        for path in paths {
            try? FileManager.default.removeItem(at: path)
        }
        return true
    }
}
