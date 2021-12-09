//
//  File.swift
//  
//
//  Created by Neo Golightly on 09.12.21.
//

import Foundation

extension String {
  func deletingPrefix(_ prefix: String) -> String {
    guard self.hasPrefix(prefix) else { return self }
    return String(self.dropFirst(prefix.count))
  }
  
  func deletingSuffix(_ suffix: String) -> String {
    guard self.hasSuffix(suffix) else { return self }
    return String(self.dropLast(suffix.count))
  }
  
  func addingPrefix(_ prefix: String) -> String {
    guard !self.hasPrefix(prefix) else { return self }
    return String(prefix+self)
  }
}
