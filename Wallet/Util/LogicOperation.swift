//
// Created by Daria Kokareva on 26.11.2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

class LogicOperation {

//  cut from CryptoSwift
//
//  CryptoSwift
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
    static func xor<T, V>(_ left: T, _ right: V) -> Array<UInt8> where T: RandomAccessCollection, V: RandomAccessCollection, T.Element == UInt8, T.Index == Int, V.Element == UInt8, V.Index == Int {
        let length = Swift.min(left.count, right.count)

        let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        buf.initialize(repeating: 0, count: length)
        defer {
            buf.deinitialize(count: length)
            buf.deallocate()
        }

        // xor
        for i in 0..<length {
            buf[i] = left[left.startIndex.advanced(by: i)] ^ right[right.startIndex.advanced(by: i)]
        }

        return Array(UnsafeBufferPointer(start: buf, count: length))
    }

}