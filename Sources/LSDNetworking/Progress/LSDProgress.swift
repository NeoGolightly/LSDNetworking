//
//  File.swift
//  
//
//  Created by Neo Golightly on 07.12.21.
//

import Foundation

public typealias LSDProgressType = [String : LSDProgress]

public struct LSDProgress{
  let expectedLength: Int
  let bytesCount: Int
  let progress: Double
}
