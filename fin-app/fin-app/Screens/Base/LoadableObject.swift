//
//  LoadableObject.swift
//  fin-app
//
//  Created by Evelina on 16.07.2025.
//

import Foundation

protocol LoadableObject: ObservableObject {
    associatedtype DataType
    var state: LoadingState<DataType> { get }
}
