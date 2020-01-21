//
//  Extensions.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 21/01/20.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
