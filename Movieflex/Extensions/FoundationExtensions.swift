//
//  FoundationExtensions.swift
//  Movieflex
//
//  Created by Shubham Singh on 17/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import Foundation

//Sequence Sorting
extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

extension Sequence where Iterator.Element: Hashable {
    func removeDuplicates() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
