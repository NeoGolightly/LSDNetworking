//
//  File.swift
//  
//
//  Created by Neo Golightly on 09.12.21.
//

import Foundation

extension URLRequest {
  
  internal init<B, R>(url: URL, request: Request<B,R>) throws {
    self.init(url: url)
    if let body = request._body {
      if request._httpMethod != .GET && request._httpMethod != .DELETE {
        let bodyData = try JSONEncoder().encode(body)
        self.httpBody = bodyData
      }
    }
    
    if let contentType = request._contentType {
      self.addValue(contentType.rawValue, forHTTPHeaderField: .contentType)
      self.addValue(contentType.rawValue, forHTTPHeaderField: .accept)
    }
    
    if let bearer = request._bearer {
      self.addValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
    }
    
    self.httpMethod = request._httpMethod.rawValue
  }
}
