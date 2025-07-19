//
//  FileCacheError.swift
//  fin-app
//
//  Created by Evelina on 16.06.2025.
//

import Foundation

enum FileCacheError: Error {
    case invalidFilePath
    case cannotReadFile
    case cannotWriteFile
}
